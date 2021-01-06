function! CreateCenteredFloatingWindow(title) abort
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {
      \ 'relative': 'editor',
      \ 'row': top,
      \ 'col': left,
      \ 'width': width,
      \ 'height': height,
      \ 'style': 'minimal',
      \ 'focusable': v:false
    \ }

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰─" . a:title . repeat("─", width - strlen(a:title) - 3) . "╯"

    let lines = [top] + repeat([mid], height - 2) + [bot]
    let border_bufnr = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(border_bufnr, 0, -1, v:true, lines)
    let s:border_winid = nvim_open_win(border_bufnr, v:true, opts)
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    let opts.focusable = v:true
    let text_bufnr = nvim_create_buf(v:false, v:true)
    call nvim_open_win(text_bufnr, v:true, opts)
    set winhl=Normal:Floating
    au WinClosed * ++once :q | call nvim_win_close(s:border_winid, v:true)
    return text_bufnr
endfunction

function! FloatingWindowEdit(query) abort
    let l:buf = CreateCenteredFloatingWindow(a:query)
    " call nvim_set_current_buf(l:buf)
    execute 'edit ' . a:query
endfunction

command! -complete=file -nargs=? Fe call FloatingWindowEdit(<q-args>)
