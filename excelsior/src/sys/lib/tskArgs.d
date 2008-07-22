DEFINITION MODULE tskArgs; (* Ned   27-Sep-89. (c) KRONOS *)
                           (* Hady. 14-Oct-89. (c) KRONOS *)

(* Стандартный разбор командной строки *)

VAL words: DYNARR OF STRING;

PROCEDURE del_word(i: INTEGER);

PROCEDURE pack_words(from,to: INTEGER);

PROCEDURE flag(prefix,f: CHAR): BOOLEAN;

PROCEDURE string(name: ARRAY OF CHAR; VAR s: STRING): BOOLEAN;

PROCEDURE number(name: ARRAY OF CHAR; VAR n: INTEGER): BOOLEAN;

PROCEDURE dispose;

PROCEDURE scan_string(str: ARRAY OF CHAR;
                      equ: BOOLEAN;
                      wds: BOOLEAN;
                      esc: BOOLEAN;
                      pre: ARRAY OF CHAR;
                      sep: ARRAY OF CHAR);

(***************************************************************

------------------------  ПРИМЕЧАНИЯ  --------------------------
                        --------------

Формат командной строки "shell" состоит из трех частей:
  [ информация для "shell" о способе запуска задачи ]
  [ имя запускаемой задачи ]
  [ параметры, передаваемые задаче при запуске ]

Данный модуль обеспечивает предварительный разбор третьей части
командной строки - параметров задачи.

Параметры задачи бывают трех видов: СЛОВА, УРАВНЕНИЯ и ФЛАГИ.

СЛОВО - непустая последовательность символов, отличных от
        пробела.
УРАВНЕНИЕ - пара: (имя + значение), где имя - СЛОВО, а значение -
        произвольная строка.
ФЛАГ -  пара: (префикс флага + ассоциированный символ).
        Разрешенный набор префиксов передается параметром
        процедуре, разбирающей строку параметров задачи (см. ниже).
        Слово, начинающееся с одного из префиксов флагов,
        задает множество флагов с данным префиксом и ассоциированных
        с символами, находящимися в слове после символа-префикса.

При инициализации модуля строка параметров задачи разбирается
стандартным образом вызовом процедуры scan_string (см.ниже):
    scan_string(parm_string,
                   equ=TRUE,
                   wds=TRUE,
                   esc=TRUE,
                   pre="+-",
                   sep='""'"''");
В дальнейшем собранные множества могут быть пересобраны
явным вызовом данной прцедуры с параметрами, определенными
пользователем, а также с ними возможны следующие операции:

ФЛАГИ:
  PROCEDURE flag(prefix,f: CHAR): BOOLEAN;
  ----------------------------------------
  Выдает значение TRUE, если в множестве флагов
  существует множество флагов, заданных символом prefix
  и в нем есть флаг, ассоциированный с символом "f".

СЛОВА:

  VAL words: DYNARR OF STRING;
  ----------------------------
  Массив содержит все выделенные при разборе строки слова.

  PROCEDURE del_word(i: INTEGER);
  -------------------------------
  Удаляет из массива words слово с индексом i.

  PROCEDURE pack_words(from,to: INTEGER);
  ---------------------------------------
  Если "from" и "to" находятся в пределах {0..HIGH(words)}, то
  собирает все words[i] для i=from..to в одну строку, разделяя
  их пробелами и удаляя из массива "words", и помещает
  результат в "words[from]".


УРАВНЕНИЯ:

  PROCEDURE string(name: ARRAY OF CHAR; VAR s: STRING): BOOLEAN;
  --------------------------------------------------------------
  Ищет уравнение с именем "name". Если находит, то
  копирует его значение в "s" и возвращают TRUE.
  Уравнение ищется сначала среди уравнений, выбранных при
  разборе командной строки, если не находится, то
  делается попытка найти его в текстовом окружении задачи
  (см. Environment.d)

  PROCEDURE number(name: ARRAY OF CHAR; VAR n: INTEGER): BOOLEAN;
  ---------------------------------------------------------------
  Аналогично string, кроме того преобразует
  строку в число (если можно).

ДОПОЛНИТЕЛЬНЫЕ ВОЗМОЖНОСТИ:

  PROCEDURE release;
  ------------------
  Освобождение всей занятой памяти


  PROCEDURE scan_string(str: ARRAY OF CHAR;-- разбираемая строка
  --------------------------------------------------------------
                        equ: BOOLEAN;      -- обработка равенств
                        wds: BOOLEAN;      -- обработка слов
                        esc: BOOLEAN       -- вкл/выкл "\"
                        pre: ARRAY OF CHAR;-- префиксы флагов
                        sep: ARRAY OF CHAR -- пары разделителей
                       );
  Очищает текущее состояние всех множеств и разбирает
  строку "s" в соответствии с остальными параметрами.

  СИНТАКСИС:
    str = { {" "} term {" "} } .

    term = word | equation | flags .
    word = charF { charN } .
    equation = name "=" body .
    flags = prefix { char } .
  
    name = charF { charN } .
    body = charB { char } | sep0 { charS } sep1 .
    prefix = один из символов "pre".
  
    IF esc=TRUE THEN
      char  = anychar | "\ " | "\\" .
      charF = anychar кроме prefix | "\ " | "\\" | "\"prefix .
      charN = anychar кроме "=" | "\ " | "\\" | "\=" .
      charB = anychar кроме sep0 | "\ " | "\\" | "\"sep0 .
      charS = anychar кроме СООТВЕТСТВУЮЩЕГО sep1 | "\\" | "\"sep1 .
    ELSE
      char  = anychar .
      charF = anychar кроме prefix .
      charN = anychar кроме "=" .
      charB = anychar кроме sep0 .
      charS = anychar кроме СООТВЕТСТВУЮЩЕГО sep1 .
    END
  
    sep0    = символ sep[i*2]   для некоторго i IN {0..HIGH(sep) DIV 2}
    sep1    = символ sep[i*2+1] для того же   i, что и в sep0.
    anychar = любой символ, кроме " " или 0c.

  ПРИМЕЧАНИЯ:
    Параметр "sep" состоит из пар (sep0,sep1) и ставит в
    соответствие открывающему разделителю закрывающий.
    Данная строка может быть пустой. Если количество
    символов в ней до 0c или HIGH нечетно, то
    sep0=sep1=последнему символу.

  Разбор строки состоит в последовательно выполняемых
  операциях ОБРАБОТКИ ФЛАГОВ, ОБРАБОТКИ УРАВНЕНИЙ,
  ОБРАБОТКИ СЛОВ.

  ОБРАБОТКА ФЛАГОВ (pre#"").

   1. Выделяет и УДАЛЯЕТ(!) из строки все слова,
      начинающиеся с символов, заданных строкой "pre"
      и формирует множество флагов для каждого
      символа из "pre".
      Например при "pre" = "+-" :
       "+abc" - флаги { (+,a), (+,b), (+,c) } ;
       "-abc" - флаги { (-,a), (-,b), (-,c) } ;
       "-+-"  - флаги { (-,+), (-,-) } ;
       "++-"  - флаги { (+,+), (+,-) } ;

      Если "esc"=TRUE, и слово начинается с символа "\"
      то данное слово не считается набором флагов даже
      в том случае если символ "\" находится в строке
      "pre". (см ОГРАНИЧЕНИЯ)

      В этом режиме комбинация "\ " заменяется на " " и
      пробел в этом случае не считается признаком конца
      набора флагов. Комбинация "\\" заменяется на "\".
      Например :
       "+a\ +\\"  дает флаги { (+,a), (+," "), (+,+), (+,\) }
       "\+ab\ +"   не является набором флагов и превращается
                    в слово "+ab +".

  ОБРАБОТКА УРАВНЕНИЙ (equ=TRUE).

   2. Если задана обработка уравнений (equ=TRUE), то
      после сбора флагов собирает и УДАЛЯЕТ(!) из строки
      все комбинации вида name=body, где name - слово,
      (то есть последовательность любых символов кроме
      пробела), а body - это слово, или ограниченная
      разделителями последовательность любых символов.
      Строка sep содержит пары (левый,правый) допустимых
      разделителей.
      Например при sep = "[]"
       "abc=def"       дает равенство ("abc","def") ;
       "abc=[000 111]  дает равенство ("abc","000 111") ;
            при sep = ""
       "abc=def"       дает равенство ("abc","def")  ;
       "abc=[000 111]  дает равенство ("abc","[000")
                              и слово "111]";

      Если esc=TRUE то комбинация "\=" во всех позициях
      слова кроме первой обозначает символ "=", и не
      является признаком уравнения. "\ " обозначает " "
      и не является признаком завершения имени или значения
      уравнения, "\\" обозначает "\".
      Пример:
       "abc\=de\\f"  дает слово      "abc=de\f".
       "ab\ c=de\ f" дает уравнение ("ab c","de f").
      При использовании пар разделителей (sep0,sep1)
      комбинация "\"sep0 сразу за символом "=", обозначает
      sep0 и значение уравнения считается не строкой, а
      словом. Если же значение начинается с символа sep0,
      то в значении комбинация "\"sep1 обозначает sep1
      и не является признаком окончания значения.
      Пример (sep="[]", esc=TRUE):
       "abc=\[def"         дает уравнение ("abc","[def") ;
       "abc=[def [\] ijk]" дает уравнение ("abc","def [] ijk") ;

  СЛОВА (wds=TRUE).
      Выделяет все слова, и формирует массив слов. Иначе
      все, что осталось в строке параметров после извлечения
      равенств и флагов заносится в строку words[0].
      Если esc=TRUE то комбинация "\=" во всех позициях
      слова кроме первой обозначает символ "=", и не
      является признаком уравнения. "\ " обозначает " "
      и не является признаком завершения слова. Комбинация
      "\\" обозначает "\".

  ОГРАНИЧЕНИЯ:
      Если "esc"=TRUE, то символ "\" в строках pre, sep
      игнорируется.
      Если "equ"=FALSE, то символ "=" теряет свое специальное
      значение ("abc=def" обрабатывается как СЛОВО).


***************************************************************)


END tskArgs.
