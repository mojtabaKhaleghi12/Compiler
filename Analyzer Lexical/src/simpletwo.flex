/*
 * Copyright 2020, Gerwin Klein, Régis Décamps, Steve Rowe
 * SPDX-License-Identifier: BSD-3-Clause
 */

%%
%public
%class compilerFaz1
%unicode
%line
%column
%char
%state COMMENT
%standalone

%{
  private StringBuilder multiLineComment = new StringBuilder();
  private long commentStartLine = 0;
  private long commentStartColumn = 0;
  private long lineStartChar = 0;

%}

ALPHA=[A-Za-z]
DIGIT=[0-9]
HEX_DIGIT=[0-9a-fA-F]
BIN_DIGIT=[01]
OCT_DIGIT=[0-7]
Ident = {ALPHA}({ALPHA}|{DIGIT}|_)*
STRING_TEXT=(\\\"|[^\n\r\"\\]|\\[btnrf\\'\"])*

mathematicalOperator = "++" | "--" | "+" | "-" | "*" | "/" | "%"
comparisonOperator = "==" | "!=" | ">=" | "<=" | ">" | "<"
logicalOperator = "&&" | "||" | "!"
bitOperator = "<<" | ">>" | "~" | "^" | "|" | "&"
assignmentOperator = "=" | "+=" | "-=" | "*=" | "/=" | "%="
separator = ";" | "," | ":" | "(" | ")" | "{" | "}"

Keywords = "int" | "float" | "double" | "char" | "bool" | "string" |
           "if" | "else" | "switch" | "case" | "for" | "while" | "do" |
           "break" | "continue" | "return" | "default" | "class" |
           "public" | "private" | "protected" | "template" | "static" | "const"
Macro = \#(include|define|ifndef|ifdef|undef|if|else|endif|elif)

%%

<YYINITIAL> {
  {Macro} {
    System.out.println("Preprocessor Directive (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1) );
  }

  {mathematicalOperator} {
    System.out.println("Arithmetic Operator (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  {comparisonOperator} {
    System.out.println("Comparison Operator (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  {logicalOperator} {
    System.out.println("Logical Operator (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  {bitOperator} {
    System.out.println("Bit Operator (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  {assignmentOperator} {
    System.out.println("Assignment Operator (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  {separator} {
    System.out.println("Separator (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  {Keywords} {
    System.out.println("Keyword (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  {Ident} {
    System.out.println("Identifier (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  0b{BIN_DIGIT}+ {
    System.out.println("Binary Literal (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  0x{HEX_DIGIT}+ {
    System.out.println("Hexadecimal Literal (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  0{OCT_DIGIT}+ {
    System.out.println("Octal Literal (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  {DIGIT}+"."{DIGIT}+([eE][+-]?{DIGIT}+)? {
    System.out.println("Float Literal (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  {DIGIT}+[eE][+-]?{DIGIT}+ {
    System.out.println("Float Literal (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  {DIGIT}+ {
    System.out.println("Integer Literal (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  \"{STRING_TEXT}\" {
    System.out.println("String (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  '([^'\\]|\\.)' {
    System.out.println("Character (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  "//".* {
    System.out.println("Single Line Comment (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  "/*" {
    yybegin(COMMENT);
    multiLineComment.setLength(0);
    multiLineComment.append("/*");
    commentStartLine = yyline + 1;
    commentStartColumn = (yychar - lineStartChar + 1);
  }

  [ \t\r\f]+ { }
  \n {
    lineStartChar = yychar + 1;
  }

  \"{STRING_TEXT} {
    System.out.println("Unterminated String (" + yytext() + ") - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }

  . {
    System.out.println("Illegal character: <" + yytext() + "> - Line " + (yyline + 1) + ", Column " + (yycolumn + 1));
  }
}

<COMMENT> {
  "*/" {
    multiLineComment.append("*/");
    System.out.println("Multi Line Comment (" + multiLineComment.toString() + ") - Line " + commentStartLine + ", Column " + commentStartColumn);
    yybegin(YYINITIAL);
  }

  [^*\n\r]+ { multiLineComment.append(yytext()); }
  "*" { multiLineComment.append("*"); }
  [\n\r] { multiLineComment.append(yytext()); }
}