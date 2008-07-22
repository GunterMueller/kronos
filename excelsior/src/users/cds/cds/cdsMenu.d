DEFINITION MODULE cdsMenu; (* Sem 07-Feb-91. (c) KRONOS *)

FROM SYSTEM      IMPORT WORD;
FROM libWindows  IMPORT window;

TYPE
  menu_proc=PROCEDURE (window, INTEGER, WORD);

PROCEDURE text_frame(w: window; x,y,sx,sy,c: INTEGER; s: ARRAY OF CHAR);
PROCEDURE white_box(w: window; x,y,sx,sy: INTEGER);

PROCEDURE message(x,y,cb,cf: INTEGER; fmt: ARRAY OF CHAR; SEQ x: WORD);
-- открывает окошко с текстом
-- x,y    координаты окошка
-- cb,cf  цвет фона и текста

PROCEDURE menu(x,y: INTEGER; sel: menu_proc; fmt: ARRAY OF CHAR; SEQ a: WORD);
PROCEDURE tmp_menu(x,y: INTEGER; fmt: ARRAY OF CHAR; SEQ a: WORD): INTEGER;

PROCEDURE readln(x,y: INTEGER; pmt: ARRAY OF CHAR; VAR s: ARRAY OF CHAR);

PROCEDURE qwest(x,y: INTEGER; fmt: ARRAY OF CHAR; SEQ a: WORD): BOOLEAN;

PROCEDURE edit_number(w: window; x,y,sx,sy: INTEGER; ch: CHAR;
                      fr,to: INTEGER; VAR num: INTEGER);
PROCEDURE pcb_number(w: window; x,y,cx,cy: INTEGER; ch: CHAR;
                     VAR num: INTEGER): BOOLEAN;

PROCEDURE zoom;
PROCEDURE rainbow;

END cdsMenu.
