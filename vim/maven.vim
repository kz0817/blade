set makeprg=mvn\ -B\ compile
set efm=%A[%t%.%#]\ %f:[%l\\,%c]\ %m,%C\ \ %m,%+G[ERROR]\ Failed\ to\ execute\ goal%m,%-G%.%#

function! EditMavenCompileResultForQuickFix()
  let qflist = getqflist()
  let newlist = []
  for qf in qflist
    " Cut lines after the following, because they are duplicated.
    if qf.text =~ "^\\[ERROR] Failed to execute goal"
      break
    end

    " The \n is replaced with ' ' when it's shown. I like ', ' than it.
    let qf.text = substitute(qf.text, '\n', ', ', "g")
    call add(newlist, qf)
  endfor
  call setqflist(newlist)
endfunction

au QuickfixCmdPost make call EditMavenCompileResultForQuickFix()
