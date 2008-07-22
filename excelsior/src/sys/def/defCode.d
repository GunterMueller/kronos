DEFINITION MODULE defCode; (* Ned 01-Dec-89. (c) KRONOS *)

(* Определяет стандарт кода *)

CONST
  info_size  = 16;       (* размер информационной части     *)
  vers_mask  = {0..7};   (* маска номера версии в поле vers *)
  cur_vers   = {1};      (* текущий номер версии            *)
  check_time = {8};      (* признак контроля времени        *)
  cpu_mask   = {24..31}; (* система команд                  *)

TYPE
  code_ptr = POINTER TO code_rec;
  code_rec = RECORD
               vers     : BITSET;  -- версия кода
               def_time : INTEGER;
               imp_time : INTEGER;
               str_size : INTEGER; -- размер строкового пула
               code_size: INTEGER; -- размер кода
               min_stack: INTEGER; -- минимальный размер стека
               add_stack: INTEGER; -- оценка стека
               glo_size : INTEGER; -- размер глобальной области
               no_exts  : INTEGER; -- размер локальной DFT
               no_proc  : INTEGER; -- число процедур
               no_mg    : INTEGER; -- число мультиглобалов
               size     : INTEGER; -- размер кода
               language : ARRAY [0..3] OF CHAR;
               tag      : INTEGER;
               usercode : BITSET;  -- наследуется из файла
               unused__F: INTEGER;
             END;

(***************************************************************

-------------------------  ПРИМЕЧАНИЯ  -------------------------
                         --------------

Структура кода (c: code_ptr):

        - информационная часть <c>;
        - строковый пул <info_size>;
          начинается с имени модуля;
        - код <info_size+c^.str_size>;
          состоит из процедурной таблицы и собствено
          кода процедур;
        - таблица мультиглобалов
          <info_size+c^.str_size+c^.code_size>
          состоит из пар слов:
          номер в глобальной области и размер в словах;
        - список импорта
          <info_size+c^.str_size+c^.code_size+c^.no_mg*2>
          состоит из времени компиляции
          соответствующего определяющего модуля и
          имени модуля, дополненного символами 0c до
          границы слова (один символ 0c всегда есть).
          Число имен в списке импорта = no_exts-1.

     После   имени  раздела  указывается  адрес  начала  раздела
относительно начала кода.

c^.vers:
        - содержит в младшем байте номер текущей версии
          кода и в остальных дополнительные признаки.

c^.glo_size:
        - определяет размер глобальной области,
          которая состоит из локальной DFT (размером c^.no_exts)
          и области для глоабльных переменных
          (размером c^.glo_size-c^.no_exts).

c^.no_exts:
        - определяет размер локальной DFT. Он равен числу
          импортируемых модулей плюс 1.

c^.min_stack:
        - определяет минимальный размер стека для модуля.
          При загрузке задачи минимальный размер стека для
          задачи получается как сумма минимальных размеров для
          всех модулей задачи.

c^.add_stack:
        - оценка дополнительного размера стека вычисляемая
          компилятором.
          При загрузке задачи оценка стека задачи есть
          максимум из оценок стеков модулей.

c^.no_mg:
        - число мультиглобалов модуля.
          размер таблицы мультиглобалов равен c^.no_mg*2.

c^.language:
        - мнемоника языка и/или компилятора (не используется
          загрузчиком).

***************************************************************)

END defCode.
