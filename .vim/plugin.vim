" %s/\s\+\/\/.\+$//
" let g:current_slide_number= 1

function! s:ReplaceWithOutput(contents)
  let filepath = <SID>WriteToFile(a:contents)
  let output = system('phantasm ' . filepath)
  let output_without_newlines = <SID>FormattedOutput(output)

  let content = getline('.')
  let content_without_comments = substitute(content, '\s\+\/\/.\+$', '', '')
  let content_length = strlen(content_without_comments)
  let spaces_count = 40 - content_length
  let spaces = repeat(' ', spaces_count)
  let insertable_content = content_without_comments . spaces . '// ' . output_without_newlines
  call setline('.', insertable_content)
endfunction

function! s:WriteToFile(list)
  let temp_file = tempname()
  call writefile(a:list, temp_file)
  return temp_file
endfunction

function! s:FormattedOutput(output)
  let results = split(a:output, "\n")

  if len(results)
    return results[-1]
  else
    return ''
  endif
endfunction

function! s:AddLineOutput()
  let original_content = <SID>ContentWithoutComments()

  let escaped_contents = escape(original_content, '"')
  let content = ['console.log(' . escaped_contents . ')']
  call <SID>ReplaceWithOutput(content)
endfunction

function! s:AddParagraphOutput()
  let end_line_number = line('.')
  call search('^\/\/--')
  normal j
  let start_line_number = line('.')
  execute 'normal ' . end_line_number . 'gg'

  let contents = []
  for line_number in range(start_line_number, end_line_number)
    call add(contents, getline(line_number))
  endfor

  call <SID>ReplaceWithOutput(contents)
endfunction

function! s:ContentWithoutComments()
  let content = getline('.')
  return substitute(content, '\s\+\/\/.\+$', '', '')
endfunction

function! s:AppendNextSlide()
  let contents = readfile('slides/' . g:current_slide_number)
  call append(line('$'), contents)
  call append(line('$'), '')

  let g:current_slide_number += 1
endfunction

function! s:DecrementCurrentSlideCount()
  let g:current_slide_number -= 1
endfunction

let g:current_slide_number = 1

nmap <F6>rl :call <SID>AddLineOutput()<CR>
nmap <F6>rp :call <SID>AddParagraphOutput()<CR>
nmap <F6>rn :call <SID>AppendNextSlide()<CR>
nmap <F6>ru :call <SID>DecrementCurrentSlideCount()<CR>
