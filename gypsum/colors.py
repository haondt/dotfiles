# Prints out all 16 colors (bright & dark)
# against each other as both the foreground
# and background colors

text = ' gYiw ' # the test text

colors = {
    'color0': { 'fg': '30', 'bg': '40' },
    'color1': { 'fg': '31', 'bg': '41' },
    'color2': { 'fg': '32', 'bg': '42' },
    'color3': { 'fg': '33', 'bg': '43' },
    'color4': { 'fg': '34', 'bg': '44' },
    'color5': { 'fg': '35', 'bg': '45' },
    'color6': { 'fg': '36', 'bg': '46' },
    'color7': { 'fg': '37', 'bg': '47' },
    'color8': { 'fg': '90', 'bg': '100'},
    'color9': { 'fg': '91', 'bg': '101'},
    'color10': { 'fg': '92', 'bg': '102'},
    'color11': { 'fg': '93', 'bg': '103'},
    'color12': { 'fg': '94', 'bg': '104'},
    'color13': { 'fg': '95', 'bg': '105'},
    'color14': { 'fg': '96', 'bg': '106'},
    'color15': { 'fg': '97', 'bg': '107'},
}

names = {
    'black': {
        'dark': 'color0',
        'bright': 'color8'
    },
    'red': {
        'dark': 'color1',
        'bright': 'color9'
    },
    'green': {
        'dark': 'color2',
        'bright': 'color10'
    },
    'yellow': {
        'dark': 'color3',
        'bright': 'color11'
    },
    'blue': {
        'dark': 'color4',
        'bright': 'color12'
    },
    'magenta': {
        'dark': 'color5',
        'bright': 'color13'
    },
    'cyan': {
        'dark': 'color6',
        'bright': 'color14'
    },
    'white': {
        'dark': 'color7',
        'bright': 'color15'
    }
}


lines = []
columns = []
columns_done = False
for fg_name in names:
    for fg_shade in ['dark', 'bright']:
        fg_id = names[fg_name][fg_shade]
        fg = colors[fg_id]['fg']
        line = []
        line.append(f'{fg_shade} {fg_name}')
        line.append(f' {fg_id} '.ljust(9))
        for bg_name in names:
            for bg_shade in ['dark', 'bright']:
                bg_id = names[bg_name][bg_shade]
                bg = colors[bg_id]['bg']
                line.append(f'\033[{fg}m\033[{bg}m{text}\033[0m')
                if not columns_done:
                    bg_id_num = bg_id[-2:]
                    if bg_id_num[0] == 'r':
                        columns.append(f' {bg_shade[0]}{bg_name[0]}{bg_id_num[1]}  ')
                    else:
                        columns.append(f' {bg_shade[0]}{bg_name[0]}{bg_id_num} ')
        columns_done = True
        lines.append(line)

max_left_col_len = max([len(i[0]) for i in lines])
for line in lines:
    line[0] = line[0].center(max_left_col_len)

header = ''
header += 'foreground \\ background '.center(len(lines[0][0] + lines[0][1]))
header += '|'
header += '|'.join(columns)

print()
print(header)
print(''.join(['-']*len(header)))
print('\n'.join([' '.join(i) for i in lines]))
print()
