" Make sure vim was compiled with Python support
if !has("python")
    echo "Please compile vim with python support for this plugin to work"
    finish
endif

function! TutsPlusMD()
python << endpython
import vim
import sys
import re

try:
    from misaka import Markdown, HtmlRenderer, EXT_FENCED_CODE

    class TutsPlusRenderer(HtmlRenderer):
        def block_code(self, text, lang):
            lang = lang or 'text'
            return '\n[%s]%s[/%s]\n' % (lang, text, lang)

        def image(self, link, title, alt_text):
            return "<!-- start img --><div class='tutorial_image'><img src='%s' alt='%s' title='%s' border='0'></div><!-- end img -->" % (link, alt_text, title)

        def header(self, text, level):
            level = 2 if level == 1 else level
            elem = '\n'
            elem = '%s<hr>\n' % elem if level == 2 else elem
            elem = '%s<h%s>%s</h%s>' % (elem, level, text, level)
            return elem


    def escape_underscore(matchobj):
        if matchobj.group(0)[:2] != '__':
            replaced = re.sub('_', '\_', matchobj.group(0))
            return replaced
        return matchobj.group(0)

    def newline(matchobj):
        return re.sub(r'^(.+)$', '\1 ', matchobj.group(0))

    def convert(contents):
        markdown = Markdown(TutsPlusRenderer(), EXT_FENCED_CODE)

        contents = re.sub(r'(\w+_\w+_\w[\w_]*)', escape_underscore, contents)
        contents = re.sub(re.compile(r'(\A|^$\n)(^\w[^\n]*\n)(^\w[^\n]*$)+', re.MULTILINE), newline, contents)

        converted = markdown.render(contents)

        converted = re.sub(r'(<p>)?<!-- start img -->', '', converted)
        converted = re.sub(r'<!-- end img -->(</p>)?', '', converted)

        return converted

    buff = vim.current.buffer
    buff_str = '\n'.join([i for i in buff])

    # create new buffer
    vim.command('e output.html')
    vim.command('b output.html')
    vim.command('set modifiable')
    vim.command('set ft=html')

    # get output.html buffer
    for buffer_ in vim.buffers:
        if 'output.html' in buffer_.name:
            out_buffer = buffer_
            break

    out_buffer[:] = None # delete buffer first

    html = convert(buff_str)
    html_list = html.split('\n')

    # for some reason appending a list doesn't work
    for i in range(len(html_list)):
        out_buffer.append(str(html_list[i]), i)
    out_buffer[-2:] = None # last two lines are blank

except ImportError:
    print "Please install misaka and ensure it is in PYTHONPATH"
    pass
endpython
endfunction

command! -nargs=0 TutsPlusMD call TutsPlusMD()
nmap <C-m> :TutsPlusMD<CR>
