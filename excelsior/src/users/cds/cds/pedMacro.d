DEFINITION MODULE pedMacro; (* Sem 12-May-87. (c) KRONOS *)

IMPORT  mdl : pedModel;
IMPORT  pcu : pedCU;

PROCEDURE define_macro(from: mdl.board; x1,y1,x2,y2: INTEGER;
                       VAR to: mdl.board);

PROCEDURE delete_box(brd: mdl.board; VAR box: pcu.range);
-- box in  - удаляемая область
-- box out - область охваченная изменениями

(*
PROCEDURE InsertMacro(x,y: INTEGER; shtd,shts: Sheet);

PROCEDURE InsertMetalMacro(x,y: INTEGER; shtd,shts: Sheet);


PROCEDURE DefineChipMacro(sht: Sheet; x1,y1,x2,y2: INTEGER);

PROCEDURE DoChipMacro(sht: Sheet; x,y: INTEGER; Do: chip_proc);
*)

END pedMacro.
