from qutebrowser.api import cmdutils

try:
    @cmdutils.register(instance='command-dispatcher', scope='window')
    @cmdutils.argument('count', value=cmdutils.Value.count)
    def back_or_close(self, count=1):
        try:self.back(count=count)
        except cmdutils.CommandError:self.tab_close()
except ValueError:pass


c.colors.webpage.prefers_color_scheme_dark = True

c.auto_save.session = False

c.content.autoplay = False

# Type: SessionName
c.session.default_name = 'backup'

c.url.default_page = 'data:text/html,%3Chtml%20contenteditable%3E%3Cstyle%3Ebody%7Bbackground-color:rgb(35,40,49);color:rgb(229,233,240);font-size:15px;%7D:empty%7Bcaret-color:transparent;%7D%3C/style%3E%3Cscript%3Ewindow.onload=function()%7Bdocument.body.focus();%7D%3C/script%3E'
c.url.start_pages = c.url.default_page

c.url.searchengines['r'] = 'https://www.reddit.com/r/{}'

c.confirm_quit = ['downloads']

c.downloads.location.remember = False
c.downloads.location.prompt = True

# Type: BoolAsk
c.content.geolocation = True

c.content.notifications = False

c.hints.chars = 'pgclaoeuidhsjkxbwv'

c.content.host_blocking.enabled = False

# Automatically enter insert mode if an editable element is focused after loading the page.
c.input.insert_mode.auto_load = False

# Show javascript alerts.
c.content.javascript.alert = False

c.keyhint.delay = 0

c.tabs.last_close = 'default-page'

c.scrolling.smooth = True

# Load a restored tab as soon as it takes focus.
c.session.lazy_restore = False

c.content.pdfjs = True

c.content.plugins = True

c.completion.open_categories.remove('searchengines')
c.completion.timestamp_format = '%Y-%m-%d'

# Limit fullscreen to the browser window (does not expand to fill the screen).
c.content.fullscreen.window = True

# Number of zoom increments to divide the mouse wheel movements to.
c.zoom.mouse_divider = 1024

# Enable JavaScript.
config.set('content.javascript.enabled', True, 'file://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')

config.set('hints.selectors', {
    **c.hints.selectors,
    'playpause': ['.ytp-play-button'],
    'next': ['.ytp-next-button'],
    'prev': ['.ytp-prev-button'],
})

# Per-site settings
# Example: config.set('content.javascript.enabled', True, '*://c01dit.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) QtWebEngine/5.12.2 Chrome/69.0.3497.128 Safari/537.36', '*://drive.google.com/*')
# config.set('downloads.location.prompt', False, '*://osu.ppy.sh/beatmapsets/*')


# c.content.user_stylesheets = 'css/themeColors-everything-css-master/css/themeColors-dark/themeColors-dark-all-sites.css'

# Aliases
c.aliases['mpv'] = 'spawn mpv {url}'
c.aliases['session-only'] = 'session-save --only'
c.aliases['so'] = 'session-save --only'
c.aliases['notes'] = 'spawn --userscript smart-open file:///home/isaacelenbaas/Notes/'
c.aliases['desmos'] = 'spawn --userscript smart-open file:///home/isaacelenbaas/Projects/Desmos/index.html'
# c.aliases['themeColors-toggle'] = "config-cycle content.user_stylesheets 'css/themeColors-everything-css-master/css/themeColors-dark/themeColors-dark-all-sites.css' ''"

# Bindings
c.bindings.default = {}
c.bindings.commands['caret'] = {
    '<Escape>'          : 'leave-mode',
}
c.bindings.commands['command'] = {
    '<Return>'          : 'command-accept',
    '<Escape>'          : 'leave-mode ;; search',
    '<Up>'              : 'completion-item-focus --history prev',
    '<Down>'            : 'completion-item-focus --history next',
    '<Tab>'             : 'search-next ;; completion-item-focus next-category',
    '<Shift-Tab>'       : 'search-prev',
}
c.bindings.commands['hint'] = {
    '<Return>'          : 'follow-hint',
    '<Escape>'          : 'leave-mode',
    'f'                 : 'set --temp hints.chars gcldhsvz ;; leave-mode ;; hint',
    'm'                 : 'hint links spawn mpv {hint-url} --pause',
    'nm'                : 'hint links spawn mpv {hint-url} --title=noMin',
    'rm'                : 'hint --rapid links spawn mpv {hint-url} --pause',
    'rt'                : 'hint --rapid all tab-bg',
    't'                 : 'hint all tab-bg',
    'y'                 : 'hint links yank',
}
c.bindings.commands['insert'] = {
    '<Escape>'          : 'leave-mode',
}
c.bindings.commands['normal'] = {
    'wl'                : 'session-save --only last ;; close',

    '<Return>'          : 'follow-selected',
    '+'                 : 'zoom-in',
    '-'                 : 'zoom-out',
    '/'                 : 'set-cmd-text /',
    ':'                 : 'set-cmd-text :',
    '<Shift-Q>'           : 'set-cmd-text :',
    '<Ctrl-n>'          : 'open -w',
    '<Ctrl-Shift-N>'    : 'open -p',

    'b'                 : 'back-or-close',

    'd'                 : 'tab-close',

    'f'                 : 'set --temp hints.chars pgclaoeuidhsjkxbwv ;; hint',

    'gg'                : 'tab-focus -1',
    'gc'                : 'tab-move ;; tab-move -',
    'gl'                : 'tab-move -',
    'gr'                : 'tab-move +',

    'h'                 : 'tab-prev',

    'i'                 : 'enter-mode insert',

    'm'                 : 'forward',

    'n'                 : 'tab-next',

    'o'                 : 'set-cmd-text -s :open',
    'O'                 : 'set-cmd-text -s :open -t',
    '.'                 : 'set-cmd-text :open !',
    '!'                 : 'set-cmd-text :open -t !',

    'p'                 : 'print',

    'r'                 : 'reload',

    'ss'                : 'scroll-to-perc 0',
    's1'                : 'scroll-to-perc 10',
    's2'                : 'scroll-to-perc 20',
    's3'                : 'scroll-to-perc 30',
    's4'                : 'scroll-to-perc 40',
    's5'                : 'scroll-to-perc 50',
    's6'                : 'scroll-to-perc 60',
    's7'                : 'scroll-to-perc 70',
    's8'                : 'scroll-to-perc 80',
    's9'                : 'scroll-to-perc 90',
    's0'                : 'scroll-to-perc',

    'u'                 : 'undo',

    'yt'                : 'yank title',
    'yy'                : 'yank',
    'yn'                : 'click-element id ytp-next-button',
    'yp'                : 'click-element id ytp-prev-button',
}
c.bindings.commands['passthrough'] = {
    '<Ctrl-Escape>'     : 'leave-mode',
}
c.bindings.commands['prompt'] = {
    '<Return>'          : 'prompt-accept',
    '<Escape>'          : 'leave-mode',
    '<Up>'              : 'prompt-item-focus prev',
    '<Down>'            : 'prompt-item-focus next',
}
c.bindings.commands['register'] = {
    '<Escape>'          : 'leave-mode',
}
c.bindings.commands['yesno'] = {
    '<Return>'          : 'prompt-accept',
    '<Escape>'          : 'leave-mode',
    'n'                 : 'prompt-accept no',
    'y'                 : 'prompt-accept yes',
}

# Colors
themeColors = {
    'cBG'               : '#232831',
    'cFG'               : '#e5e9f0',
    'c00'               : '#282e38',
    'c01'               : '#bf616a',
    'c02'               : '#a3be8c',
    'c03'               : '#f0c674',
    'c04'               : '#81a1c1',
    'c05'               : '#b48ead',
    'c06'               : '#8fbcbb',
    'c07'               : '#707880',
    'c08'               : '#2e3440',
    'c09'               : '#d08770',
    'c11'               : '#ebcb8b',
    'c12'               : '#88c0d0',
    'c15'               : '#c5c8c6',
}
c.colors.completion.category.bg = themeColors['cBG']
c.colors.completion.category.border.bottom = c.colors.completion.category.bg
c.colors.completion.category.border.top = c.colors.completion.category.border.bottom
c.colors.completion.category.fg = themeColors['cFG']
c.colors.completion.even.bg = themeColors['c00']
c.colors.completion.odd.bg = c.colors.completion.even.bg
c.colors.completion.fg = themeColors['cFG']
c.colors.completion.item.selected.bg = themeColors['c12']
c.colors.completion.item.selected.border.bottom = c.colors.completion.item.selected.bg
c.colors.completion.item.selected.border.top = c.colors.completion.item.selected.border.bottom
c.colors.completion.item.selected.fg = themeColors['cBG']
c.colors.completion.item.selected.match.fg = themeColors['c04']
c.colors.completion.match.fg = themeColors['c07']
c.colors.completion.scrollbar.bg = themeColors['cFG']
c.colors.completion.scrollbar.fg = themeColors['c15']
c.colors.downloads.bar.bg = themeColors['cBG']
c.colors.downloads.error.bg = themeColors['c01']
c.colors.downloads.error.fg = themeColors['c03']
# Color gradient start for download backgrounds.
c.colors.downloads.start.bg = themeColors['c06']
# Color gradient start for download text.
c.colors.downloads.start.fg = themeColors['c00']
# Color gradient stop for download backgrounds.
c.colors.downloads.stop.bg = themeColors['c02']
# Color gradient end for download text.
c.colors.downloads.stop.fg = '#000000'
c.colors.hints.bg = '#434c5e'
c.colors.hints.fg = '#ffffff'
c.colors.hints.match.fg = c.colors.hints.bg
# Background color of the keyhint widget.
c.colors.keyhint.bg = themeColors['cBG']
c.colors.keyhint.fg = themeColors['c15']
c.colors.keyhint.suffix.fg = '#ffffff'
c.hints.border = '1px solid ' + themeColors['c12']
c.colors.messages.error.bg = themeColors['c01']
c.colors.messages.error.border = c.colors.messages.error.bg
c.colors.messages.error.fg = themeColors['cFG']
c.colors.messages.info.bg = themeColors['cFG']
c.colors.messages.info.border = c.colors.messages.info.border
c.colors.messages.info.fg = themeColors['cBG']
c.colors.messages.warning.bg = themeColors['c09']
c.colors.messages.warning.border = c.colors.messages.warning.bg
c.colors.messages.warning.fg = themeColors['cFG']
c.colors.prompts.bg = themeColors['cBG']
c.colors.prompts.border = c.colors.prompts.bg
c.colors.prompts.fg = themeColors['cFG']
c.colors.prompts.selected.bg = themeColors['c04']
c.colors.statusbar.caret.bg = themeColors['cBG']
c.colors.statusbar.caret.fg = themeColors['c15']
c.colors.statusbar.caret.selection.bg = c.colors.statusbar.caret.bg
c.colors.statusbar.caret.selection.fg = c.colors.statusbar.caret.fg
c.colors.statusbar.command.bg = c.colors.statusbar.caret.bg
c.colors.statusbar.command.fg = themeColors['cFG']
c.colors.statusbar.command.private.bg = c.colors.statusbar.caret.bg
c.colors.statusbar.command.private.fg = c.colors.statusbar.caret.fg
c.colors.statusbar.insert.bg = c.colors.statusbar.caret.bg
c.colors.statusbar.insert.fg = c.colors.statusbar.caret.fg
c.colors.statusbar.normal.bg = c.colors.statusbar.caret.bg
c.colors.statusbar.normal.fg = c.colors.statusbar.caret.fg
c.colors.statusbar.passthrough.bg = c.colors.statusbar.caret.bg
c.colors.statusbar.passthrough.fg = c.colors.statusbar.caret.fg
c.colors.statusbar.private.bg = '#586e75'
c.colors.statusbar.private.fg = c.colors.statusbar.caret.fg
c.colors.statusbar.progress.bg = c.colors.statusbar.normal.fg
c.colors.statusbar.url.error.fg = themeColors['c01']
c.colors.statusbar.url.fg = c.colors.statusbar.normal.fg
c.colors.statusbar.url.hover.fg = themeColors['cFG']
c.colors.statusbar.url.success.http.fg = c.colors.statusbar.url.fg
c.colors.statusbar.url.success.https.fg = c.colors.statusbar.url.fg
c.colors.statusbar.url.warn.fg = themeColors['c09']
# Background color of the tab bar.
# c.colors.tabs.bar.bg = '#555555'
c.colors.tabs.even.bg = themeColors['cBG']
c.colors.tabs.even.fg = '#9ea39f'
c.colors.tabs.odd.bg = c.colors.tabs.even.bg
c.colors.tabs.odd.fg = c.colors.tabs.even.fg
c.colors.tabs.indicator.error = themeColors['c01']
c.colors.tabs.indicator.start = themeColors['c07']
c.colors.tabs.indicator.stop = themeColors['c12']
c.colors.tabs.selected.even.bg = '#434c5e'
c.colors.tabs.selected.even.fg = '#ffffff'
c.colors.tabs.selected.odd.bg = c.colors.tabs.selected.even.bg
c.colors.tabs.selected.odd.fg = c.colors.tabs.selected.even.fg
c.colors.webpage.bg = themeColors['cFG']
