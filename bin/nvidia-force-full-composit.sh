#!/bin/sh

PATH=${PATH}:/usr/lib/nvidia/current
nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
