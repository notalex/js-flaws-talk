" %s/\\s\\+\\/\\/.\\+$//

function! s:AddOutput()
  let content = getline('.')
  let content_without_comments = substitute(content, '\s\+\/\/.\+$', '', '')
  let escaped_contents = escape(content_without_comments, '"')
  let command = 'console.log(' . escaped_contents . ')'
  let output = system('phantom-exec "' . command . '"')
  let output_without_newlines = substitute(output, "\n", '', '')

  let content_length = strlen(content_without_comments)
  let spaces_count = 40 - content_length
  let spaces = repeat(' ', spaces_count)
  let insertable_content = content_without_comments . spaces . '// ' . output_without_newlines
  call setline('.', insertable_content)
endfunction

nmap <F6>rt :call <SID>AddOutput()<CR>
