scriptencoding utf-8

let g:airline#themes#warmth#palette = {}

" Create base color scheme
let g:airline#themes#warmth#palette.normal = {
  \ 'airline_a' :[ '#f3ec98' , '#3d1d29' ,  11, 0],
  \ 'airline_b' :[ '#ffffff' , '#444444' , 11, 8 ],
  \ 'airline_c' :[ '#9cffd3' , '#202020' , 0, 10 ],
  \ 'airline_x' :[ '#f3ec98' , '#3d1d29' ,  11, 0],
  \ 'airline_y' :[ '#ffffff' , '#444444' , 11, 8 ],
  \ 'airline_z' :[ '#9cffd3' , '#202020' , 0, 10 ],
  \ 'airline_warning' :['#ffffff', '#ffffff', 235,1,'']
  \ }

" Modify center bar when buffer is modified
let g:airline#themes#warmth#palette.normal_modified = {
  \ 'airline_c' :['#ffffff', '#ffffff', 0,4,''],
  \ 'airline_warning' :['#ffffff', '#ffffff', 235,1,'']
  \ }

" Create color scheme for visual mode
let g:airline#themes#warmth#palette.visual = {
  \ 'airline_a' :[ '#f3ec98' , '#3d1d29' ,  235,6],
  \ 'airline_b' :[ '#ffffff' , '#444444' , 235,7],
  \ 'airline_c' :[ '#9cffd3' , '#202020' , 7,235 ],
  \ 'airline_x' :[ '#f3ec98' , '#3d1d29' ,  235, 6],
  \ 'airline_y' :[ '#ffffff' , '#444444' , 235, 7 ],
  \ 'airline_z' :[ '#9cffd3' , '#202020' , 7, 235 ],
  \ 'airline_warning' :['#ffffff', '#ffffff', 235,1,'']
  \ }

" Create color scheme for insert mode
let g:airline#themes#warmth#palette.insert = {
  \ 'airline_a' :[ '#f3ec98' , '#3d1d29' ,  235,4],
  \ 'airline_b' :[ '#ffffff' , '#444444' , 0,3],
  \ 'airline_c' :[ '#9cffd3' , '#202020' , 235,5 ],
  \ 'airline_x' :[ '#f3ec98' , '#3d1d29' ,  235, 4],
  \ 'airline_y' :[ '#ffffff' , '#444444' , 0, 3 ],
  \ 'airline_z' :[ '#9cffd3' , '#202020' , 235, 5 ],
  \ 'airline_warning' :['#ffffff', '#ffffff', 235,1,'']
  \ }
