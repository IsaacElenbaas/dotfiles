#{{{ imports+functions
    #{{{ imports
import re
from PyQt5.QtCore import QUrl
from qutebrowser.api import cmdutils
from qutebrowser.api import interceptor
from qutebrowser.utils import message
    #}}}

    #{{{ back_or_close
try:
    @cmdutils.register(instance='command-dispatcher', scope='window')
    @cmdutils.argument('count', value=cmdutils.Value.count)
    def back_or_close(self, count=1):
        try:self.back(count=count)
        except cmdutils.CommandError:self.tab_close()
except ValueError:pass
    #}}}

    #{{{ filter_yt
def filter_yt(info: interceptor.Request):
    if info.request_url.host() == 'www.youtube.com':
        new_url = QUrl(info.request_url)
        new_url.setHost('vid.puffyan.us')
        try:
            info.redirect(new_url, ignore_unsupported=True)
        except interceptor.RedirectException: # this registers again every time so all but one will error
            pass
interceptor.register(filter_yt)
    #}}}

    #{{{ zoom_in/out_all
try:
    @cmdutils.register(instance='command-dispatcher', scope='window')
    def zoom_in_all(self):
        lastZoom = int(c.zoom.default[:-1])
        c.zoom.default = c.zoom.levels[min(c.zoom.levels.index(c.zoom.default)+1, len(c.zoom.levels)-1)]
        c.fonts.default_size = str(float(c.fonts.default_size[:-2])/lastZoom*int(c.zoom.default[:-1])) + c.fonts.default_size[-2:]
        message.info(c.zoom.default, replace='zoom-level-all')
    @cmdutils.register(instance='command-dispatcher', scope='window')
    def zoom_out_all(self):
        lastZoom = int(c.zoom.default[:-1])
        c.zoom.default = c.zoom.levels[max(c.zoom.levels.index(c.zoom.default)-1, 0)]
        c.fonts.default_size = str(float(c.fonts.default_size[:-2])/lastZoom*int(c.zoom.default[:-1])) + c.fonts.default_size[-2:]
        message.info(c.zoom.default, replace='zoom-level-all')
except ValueError:pass
    #}}}
#}}}

#{{{ settings
c.downloads.location.prompt = True
c.content.prefers_reduced_motion = True
config.set('hints.selectors', {
    **c.hints.selectors,
    'noinputs': [i for i in c.hints.selectors['all'] if not re.match('.*(input|contenteditable|tabindex)', i)],
    'playpause': ['.ytp-play-button'],
    'next': ['.ytp-next-button'],
    'prev': ['.ytp-prev-button'],
})
c.hints.uppercase = True
c.scrolling.smooth = True
c.session.default_name = 'backup'
c.tabs.new_position.unrelated = 'next'
c.tabs.select_on_remove = 'last-used'
c.url.default_page = 'data:text/html,%3Chtml%20contenteditable%3E%3Cstyle%3Ebody%7Bbackground-color:rgb(35,40,49);color:rgb(229,233,240);font-size:15px;%7D:empty%7Bcaret-color:transparent;%7D%3C/style%3E%3Cscript%3Ewindow.onload=function()%7Bdocument.body.focus();%7D%3C/script%3E'
c.url.searchengines['r'] = 'https://www.reddit.com/r/{}'
c.zoom.default = '125%'
c.fonts.default_size = str(float(c.fonts.default_size[:-2])/100*int(c.zoom.default[:-1])) + c.fonts.default_size[-2:]
#}}}

#{{{ JS
c.content.javascript.enabled = False
config.set('content.javascript.enabled', True, '*.archive.org')
config.set('content.javascript.enabled', True, '*.coinbase.com')
config.set('content.javascript.enabled', True, '*.dhl.com')
config.set('content.javascript.enabled', True, '*.duosecurity.com')
config.set('content.javascript.enabled', True, '*.github.com')
config.set('content.javascript.enabled', True, '*.google.com')
config.set('content.javascript.enabled', True, '*.instructure.com')
config.set('content.javascript.enabled', True, '*.mtu.edu')
config.set('content.javascript.enabled', True, '*.ups.com')
config.set('content.javascript.enabled', True, 'data:*')
#}}}

#{{{ permanent settings
config.load_autoconfig(False)
try:
    c.completion.open_categories.remove('searchengines')
except ValueError:pass
c.completion.timestamp_format = '%Y-%m-%d'
c.confirm_quit = ['downloads']
c.content.autoplay = False
c.content.fullscreen.window = True
c.content.blocking.enabled = True
c.content.blocking.method = 'adblock'
c.content.javascript.can_access_clipboard = True
c.content.notifications.enabled = False
c.content.pdfjs = True
c.content.plugins = True
c.downloads.location.remember = False
c.input.forward_unbound_keys = 'none'
c.input.insert_mode.leave_on_load = False
c.keyhint.delay = 0
c.tabs.last_close = 'default-page'
c.url.start_pages = c.url.default_page
c.zoom.mouse_divider = 1024
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'file://*')
config.set('content.javascript.enabled', True, 'qute://*/*')
#}}}

#{{{ aliases
c.aliases['desmos']       = 'spawn --userscript smart-open file:///home/isaacelenbaas/Projects/Desmos/index.html'
c.aliases['mpv']          = 'spawn --detach bash -c "x=\'{url}\'; mpv \\"${x/vid\\\\.puffyan\\\\.us/www.youtube.com}\\" --force-window=yes"'
c.aliases['passthrough']  = 'mode-enter passthrough'
c.aliases['paywall']      = 'open https://www.google.com/search?q=cache:{{url}}'
c.aliases['q']            = 'session-save --only last ;; close'
c.aliases['q!']           = 'close'
c.aliases['reader']       = 'jseval -q -w main fetch("https://api.outline.com/v3/parse_article?source_url="+window.location.href).then(function(response){return response.json()}).then(function(data){document.querySelector("html").innerHTML=\'<head><title>\'+data.data.title+\'</title><link rel="stylesheet"type="text/css"href="https://outline.com/css/outline.css"><style type="text/css">.yue{max-width:650px;margin:2em auto 0 auto}.article-info>*{margin-right:0.5em}</style></head><body><div class="yue"><div class="article-info"><h1>\'+data.data.title+\'</h1><span class="author">\'+data.data.author+\'</span><span class="date">\'+data.data.date+\'</span><span class="date">\'+data.data.read_time+\' read</span></div>\'+data.data.html+\'</div></body>\'})'
c.aliases['session-only'] = 'session-save --only'
c.aliases['so']           = 'session-save --only'
c.aliases['notes']        = 'spawn --userscript smart-open file:///home/isaacelenbaas/Notes/'
c.aliases['yt']           = 'open https://vid.puffyan.us{url:path}'
#}}}

#{{{ bindings
c.bindings.default = {}

    #{{{ caret
c.bindings.commands['caret'] = {
    '<Escape>': 'mode-leave',
}
    #}}}

    #{{{ command
c.bindings.commands['command'] = {
    '<Return>'   : 'command-accept',
    '<Escape>'   : 'mode-leave ;; search',
    '<Down>'     : 'completion-item-focus --history next',
    '<Up>'       : 'completion-item-focus --history prev',
    '<Tab>'      : 'search-next ;; completion-item-focus next-category',
    '<Shift-Tab>': 'search-prev',
    '<Ctrl-D>'   : 'completion-item-del',
}
    #}}}

    #{{{ hint
c.bindings.commands['hint'] = {
    '<Return>': 'follow-hint',
    '<Escape>': 'mode-leave',
    'f'       : 'set --temp hints.chars gcrdhtnlmwvs ;; mode-leave ;; hint noinputs',
    'i'       : 'hint inputs',
    'm'       : 'hint links spawn --detach bash -c "x=\'{hint-url}\'; mpv \\"${x/vid\\\\.puffyan\\\\.us/www.youtube.com}\\" --force-window=yes --title=min --pause"',
    'nm'      : 'hint links spawn --detach bash -c "x=\'{hint-url}\'; mpv \\"${x/vid\\\\.puffyan\\\\.us/www.youtube.com}\\" --force-window=yes"',
    'rm'      : 'hint --rapid links spawn --detach bash -c "x=\'{hint-url}\'; mpv \\"${x/vid\\\\.puffyan\\\\.us/www.youtube.com}\\" --force-window=yes --title=min --pause"',
    'rt'      : 'hint --rapid all tab-bg',
    't'       : 'hint noinputs tab-bg',
    'y'       : 'hint links yank',
}
    #}}}

    #{{{ insert
c.bindings.commands['insert'] = {
    '<Escape>': 'mode-leave',
}
    #}}}

    #{{{ normal
c.bindings.commands['normal'] = {
    '<Return>'      : 'selection-follow',
    '<Down>'        : 'scroll down',
    '<Up>'          : 'scroll up',

    '+'             : 'zoom-in',
    '-'             : 'zoom-out',
    '<Ctrl-Shift-+>': 'zoom-in-all',
    '<Ctrl-->'      : 'zoom-out-all',
    '/'             : 'set-cmd-text /',
    ':'             : 'set-cmd-text :',
    'm'             : 'mode-enter set_mark',
    'tm'            : 'mode-enter jump_mark',
    '<Shift-Q>'     : 'set-cmd-text :',
    '<Ctrl-n>'      : 'open -w',
    '<Ctrl-Shift-N>': 'open -p',
    '<Ctrl-c>'      : 'fake-key <Ctrl-c>',

    'i'             : 'mode-enter insert',
    'I'             : 'hint inputs',
    'o'             : 'set-cmd-text -s :open',
    'O'             : 'set-cmd-text -s :open -t',
    '.'             : 'set-cmd-text :open !',
    '!'             : 'set-cmd-text :open -t !',
    'f'             : 'set --temp hints.chars piueokjqagcrdhtnlmwvs ;; hint noinputs',
    'r'             : 'reload',
    'p'             : 'print',

    'd'             : 'tab-close',
    'u'             : 'undo',
    'b'             : 'back-or-close',
    'm'             : 'forward',
    'gg'            : 'tab-focus -1',
    'gc'            : 'tab-move ;; tab-move -',
    'gl'            : 'tab-move -',
    'gr'            : 'tab-move +',
    'n'             : 'tab-next',
    'h'             : 'tab-prev',

    'yo'            : 'set-cmd-text :open {url}',
    'yt'            : 'yank title',
    'yy'            : 'yank',

        #{{{ scroll to percentage
    'ss'            : 'scroll-to-perc 0',
    's1'            : 'scroll-to-perc 10',
    's2'            : 'scroll-to-perc 20',
    's3'            : 'scroll-to-perc 30',
    's4'            : 'scroll-to-perc 40',
    's5'            : 'scroll-to-perc 50',
    's6'            : 'scroll-to-perc 60',
    's7'            : 'scroll-to-perc 70',
    's8'            : 'scroll-to-perc 80',
    's9'            : 'scroll-to-perc 90',
    's0'            : 'scroll-to-perc',
        #}}}

    'yn'            : 'click-element id ytp-next-button',
    'yp'            : 'click-element id ytp-prev-button',
    'wl'            : 'session-save --only last ;; close',
}
    #}}}

    #{{{ passthrough
c.bindings.commands['passthrough'] = {
    '<Ctrl-Escape>': 'mode-leave',
}
    #}}}

    #{{{ prompt
c.bindings.commands['prompt'] = {
    '<Return>': 'prompt-accept',
    '<Escape>': 'mode-leave',
    '<Down>'  : 'prompt-item-focus next',
    '<Up>'    : 'prompt-item-focus prev',
}
    #}}}

    #{{{ register
c.bindings.commands['register'] = {
    '<Escape>': 'mode-leave',
}
    #}}}

    #{{{ yesno
c.bindings.commands['yesno'] = {
    '<Return>': 'prompt-accept',
    '<Escape>': 'mode-leave',
    'n'       : 'prompt-accept no',
    'y'       : 'prompt-accept yes',
}
    #}}}
#}}}

#{{{ theming
c.colors.webpage.preferred_color_scheme = 'dark'
c.keyhint.radius = 0
c.prompt.radius = 0

    #{{{ themeColors
themeColors = {
    'cBG': '#232831',
    'cFG': '#e5e9f0',
    'c00': '#282e38',
    'c01': '#bf616a',
    'c02': '#a3be8c',
    'c03': '#f0c674',
    'c04': '#81a1c1',
    'c05': '#b48ead',
    'c06': '#8fbcbb',
    'c07': '#707880',
    'c08': '#2e3440',
    'c09': '#d08770',
    'c11': '#ebcb8b',
    'c12': '#88c0d0',
    'c15': '#c5c8c6',
}
    #}}}

    #{{{ completion
c.colors.completion.category.bg                 = themeColors['cBG']
c.colors.completion.category.border.bottom      = c.colors.completion.category.bg
c.colors.completion.category.border.top         = c.colors.completion.category.border.bottom
c.colors.completion.category.fg                 = themeColors['cFG']
c.colors.completion.even.bg                     = themeColors['c00']
c.colors.completion.odd.bg                      = c.colors.completion.even.bg
c.colors.completion.fg                          = themeColors['cFG']
c.colors.completion.item.selected.bg            = themeColors['c12']
c.colors.completion.item.selected.border.bottom = c.colors.completion.item.selected.bg
c.colors.completion.item.selected.border.top    = c.colors.completion.item.selected.border.bottom
c.colors.completion.item.selected.fg            = themeColors['cBG']
c.colors.completion.item.selected.match.fg      = themeColors['c04']
c.colors.completion.match.fg                    = themeColors['c07']
c.colors.completion.scrollbar.bg                = themeColors['cFG']
c.colors.completion.scrollbar.fg                = themeColors['c15']
    #}}}

    #{{{ downloads
c.colors.downloads.bar.bg   = themeColors['cBG']
c.colors.downloads.error.bg = themeColors['c01']
c.colors.downloads.error.fg = themeColors['c03']
c.colors.downloads.start.bg = themeColors['c06']
c.colors.downloads.start.fg = themeColors['c00']
c.colors.downloads.stop.bg  = themeColors['c02']
c.colors.downloads.stop.fg  = '#000000'
    #}}}

    #{{{ hints
c.colors.hints.bg          = '#434c5e'
c.colors.hints.fg          = '#ffffff'
c.colors.hints.match.fg    = c.colors.hints.bg
# Background color of the keyhint widget.
c.colors.keyhint.bg        = themeColors['cBG']
c.colors.keyhint.fg        = themeColors['c15']
c.colors.keyhint.suffix.fg = '#ffffff'
c.hints.border             = '1px solid ' + themeColors['c12']
    #}}}

    #{{{ messages
c.colors.messages.error.bg       = themeColors['c01']
c.colors.messages.error.border   = c.colors.messages.error.bg
c.colors.messages.error.fg       = themeColors['cFG']
c.colors.messages.info.bg        = themeColors['cFG']
c.colors.messages.info.border    = c.colors.messages.info.border
c.colors.messages.info.fg        = themeColors['cBG']
c.colors.messages.warning.bg     = themeColors['c09']
c.colors.messages.warning.border = c.colors.messages.warning.bg
c.colors.messages.warning.fg     = themeColors['cFG']
    #}}}

    #{{{ prompts
c.colors.prompts.bg          = themeColors['cBG']
c.colors.prompts.border      = c.colors.prompts.bg
c.colors.prompts.fg          = themeColors['cFG']
c.colors.prompts.selected.bg = themeColors['c04']
    #}}}

    #{{{ statusbar
c.colors.statusbar.caret.bg             = themeColors['cBG']
c.colors.statusbar.caret.fg             = themeColors['c15']
c.colors.statusbar.caret.selection.bg   = c.colors.statusbar.caret.bg
c.colors.statusbar.caret.selection.fg   = c.colors.statusbar.caret.fg
c.colors.statusbar.command.bg           = c.colors.statusbar.caret.bg
c.colors.statusbar.command.fg           = themeColors['cFG']
c.colors.statusbar.command.private.bg   = '#586e75'
c.colors.statusbar.command.private.fg   = c.colors.statusbar.caret.fg
c.colors.statusbar.insert.bg            = c.colors.statusbar.caret.bg
c.colors.statusbar.insert.fg            = c.colors.statusbar.caret.fg
c.colors.statusbar.normal.bg            = c.colors.statusbar.caret.bg
c.colors.statusbar.normal.fg            = c.colors.statusbar.caret.fg
c.colors.statusbar.passthrough.bg       = c.colors.statusbar.caret.bg
c.colors.statusbar.passthrough.fg       = c.colors.statusbar.caret.fg
c.colors.statusbar.private.bg           = c.colors.statusbar.command.private.bg
c.colors.statusbar.private.fg           = c.colors.statusbar.caret.fg
c.colors.statusbar.progress.bg          = c.colors.statusbar.normal.fg
c.colors.statusbar.url.error.fg         = themeColors['c01']
c.colors.statusbar.url.fg               = c.colors.statusbar.normal.fg
c.colors.statusbar.url.hover.fg         = themeColors['cFG']
c.colors.statusbar.url.success.http.fg  = c.colors.statusbar.url.fg
c.colors.statusbar.url.success.https.fg = c.colors.statusbar.url.fg
c.colors.statusbar.url.warn.fg          = themeColors['c09']
    #}}}

    #{{{ tab bar
# c.colors.tabs.bar.bg           = '#555555'
c.colors.tabs.even.bg          = themeColors['cBG']
c.colors.tabs.even.fg          = '#9ea39f'
c.colors.tabs.odd.bg           = c.colors.tabs.even.bg
c.colors.tabs.odd.fg           = c.colors.tabs.even.fg
c.colors.tabs.indicator.error  = themeColors['c01']
c.colors.tabs.indicator.start  = themeColors['c07']
c.colors.tabs.indicator.stop   = themeColors['c12']
c.colors.tabs.selected.even.bg = '#434c5e'
c.colors.tabs.selected.even.fg = '#ffffff'
c.colors.tabs.selected.odd.bg  = c.colors.tabs.selected.even.bg
c.colors.tabs.selected.odd.fg  = c.colors.tabs.selected.even.fg
c.colors.webpage.bg            = themeColors['cFG']
    #}}}
#}}}
