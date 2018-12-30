package main

import (
    "fmt"
    "flag"
    "os"
    "bufio"
    "strings"
    "errors"
    "time"
    "strconv"
    "math"
)

type UnitInfo struct {
    label string
    div   float64
    showLength int
}

type Args struct {
    interfaceName string
    procNetDevPath string
    interval float64
    autoUnit bool
    showExp bool
    unit string

    // set by code in this program
    unitInfo UnitInfo
}

type OneWayFlowStat struct {
    bytes uint64
    packets uint64
    timestamp time.Time
}

type FlowStat struct {
    rx OneWayFlowStat
    tx OneWayFlowStat
}

type Context struct {
    prevStat FlowStat
    currStat FlowStat
}

type OneWayThroughput struct {
    bytes float64
    packets float64
}

type Throughput struct {
    rx OneWayThroughput
    tx OneWayThroughput
}

func getInterfaceInfo(args *Args) (string, error) {
    file, err := os.Open(args.procNetDevPath)
    if err != nil {
        fmt.Errorf("Failed to open: %s: %s\n", args.interfaceName, err)
        return "", err
    }
    defer file.Close()

    var targetLine string
    const expectedNumTokens = 17
    expectedInterface := args.interfaceName + ":"
    s := bufio.NewScanner(file)
    for s.Scan() {
        line := s.Text()
        tokens := strings.Fields(line)
        if len(tokens) != expectedNumTokens {
            continue
        }
        if tokens[0] == expectedInterface {
            targetLine = line
            break
        }
    }

    if targetLine == "" {
        return "", errors.New("Not found: target interface ")
    }

    return targetLine, nil
}

func parseDevLine(line string) FlowStat {

    toNum := func(v string) uint64 {
        n, err := strconv.Atoi(v)
        if err != nil {
            fmt.Errorf("Failed to convert: %s, %s", v, err)
            os.Exit(-1)
        }
        return uint64(n)
    }

    tokens := strings.Fields(line)
    now := time.Now()
    rx := OneWayFlowStat{toNum(tokens[1]), toNum(tokens[2]), now}
    tx := OneWayFlowStat{toNum(tokens[9]), toNum(tokens[10]), now}
    return FlowStat{rx, tx}
}

func calcOneWayThroughput(prev *OneWayFlowStat, curr *OneWayFlowStat) OneWayThroughput {

    throughput := func(v uint64, dt time.Duration) float64 {
        return float64(v) / dt.Seconds()
    }

    t := curr.timestamp
    dt := t.Sub(prev.timestamp)
    dBytes := curr.bytes - prev.bytes
    dPackets := curr.packets - prev.packets
    return OneWayThroughput{throughput(dBytes, dt), throughput(dPackets, dt)}
}

func calcThroughput(ctx *Context) Throughput {
    rxThroughput := calcOneWayThroughput(&ctx.prevStat.rx, &ctx.currStat.rx)
    txThroughput := calcOneWayThroughput(&ctx.prevStat.tx, &ctx.currStat.tx)
    return Throughput{rxThroughput, txThroughput}
}

func iterate(args *Args, ctx *Context) Throughput {
    line, err := getInterfaceInfo(args)
    if err != nil {
        fmt.Errorf("Failed to read interface information: %s\n", err)
        os.Exit(-1)
    }
    ctx.currStat = parseDevLine(line)
    throughput := calcThroughput(ctx)
    ctx.prevStat = ctx.currStat
    return throughput
}

func setUnit(v float64) string {
    units :=  []string{"  B", "KiB", "MiB", "GiB", "TiB", "EiB"}
    unitIdx := 0

    for unitIdx < len(units)-1 {
        if (v < 1024.0) {
            break
        }
        v /= 1024.0
        unitIdx++
    }

    return fmt.Sprintf("%8.3f %s", v, units[unitIdx])
}

func adjustSpaces(s string, totalLength int) string {
    format := fmt.Sprintf("%%%ds", totalLength)
    return fmt.Sprintf(format, s)
}

func insertCommaEvery3Digits(v float64, showLength int) string {
    const fractionPartLen = 3
    format := fmt.Sprintf("%%.%df", fractionPartLen)
    original := fmt.Sprintf(format, v)
    origLen := len(original)

    integerPartLen := origLen - fractionPartLen - 1
    numComma := (integerPartLen - 1) / 3

    numFirstGroup := integerPartLen % 3
    if numFirstGroup == 0 {
        numFirstGroup = 3
    }

    slicePos := numFirstGroup
    processed := original[0:slicePos]
    for i := 0; i < numComma; i++ {
        processed += ","
        processed += original[slicePos:slicePos+3]
        slicePos += 3
    }
    processed += original[integerPartLen:]
    return adjustSpaces(processed, showLength)
}

func showThroughput(args *Args, throughput *Throughput) {

    var thrRxBytes string
    var thrTxBytes string

    if (args.autoUnit) {
        thrRxBytes = setUnit(throughput.rx.bytes)
        thrTxBytes = setUnit(throughput.tx.bytes)
    } else {
        unitInfo := &args.unitInfo
        thrRx := throughput.rx.bytes / unitInfo.div
        thrTx := throughput.tx.bytes / unitInfo.div

        if (args.showExp) {
            thrRxBytes = fmt.Sprintf("%.3e", thrRx)
            thrTxBytes = fmt.Sprintf("%.3e", thrTx)
        } else {
            thrRxBytes = insertCommaEvery3Digits(thrRx, unitInfo.showLength)
            thrTxBytes = insertCommaEvery3Digits(thrTx, unitInfo.showLength)
        }

        thrRxBytes += " " + unitInfo.label
        thrTxBytes += " " + unitInfo.label
    }

    fmt.Printf("[RX] %s/s, %6.1f pkts/s\n", thrRxBytes, throughput.rx.packets)
    fmt.Printf("[TX] %s/s, %6.1f pkts/s\n", thrTxBytes, throughput.tx.packets)
    fmt.Println("---")
}

func fixupUnit(args *Args) {
    unitMap := map[string]UnitInfo{
        "":  {"B",   1.0,                 15},
        "K": {"KiB", 1024.0,              12},
        "M": {"MiB", math.Pow(1024.0, 2), 9},
        "G": {"GiB", math.Pow(1024.0, 3), 6},
        "T": {"TiB", math.Pow(1024.0, 4), 3},
    }

    var found bool
    args.unitInfo, found = unitMap[strings.ToUpper(args.unit)]
    if found == false {
        fmt.Errorf("Unknown unit: %s\n", args.unit)
        os.Exit(-1)
    }
}

func main() {
    args := &Args{}
    flag.StringVar(&args.procNetDevPath, "p",
                   "/proc/net/dev", "Proc netdev file path")
    flag.StringVar(&args.interfaceName, "i",
                   "eth0", "Network interface name")
    flag.Float64Var(&args.interval, "t", 1, "Interval (sec)")
    flag.BoolVar(&args.autoUnit, "a", false, "Automatic unit selection")
    flag.BoolVar(&args.showExp, "e", false, "Show result as expo. style")
    flag.StringVar(&args.unit, "u", "", "Unit: K, M, G, T")
    flag.Parse()

    fixupUnit(args)
    fmt.Printf("Interface: %s\n", args.interfaceName)
    fmt.Printf("Interval : %.1f\n", args.interval)

    ctx := &Context{}
    iterate(args, ctx)
    for {
        time.Sleep(time.Duration(args.interval) * time.Second)
        throughput := iterate(args, ctx)
        showThroughput(args, &throughput)
    }
}
