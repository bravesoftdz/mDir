{ MDir - iMproved Dir }
{ Copyright (c) René Hickersberger }

program mDir;

{$APPTYPE CONSOLE}
{$MODE objfpc}

uses SysUtils, Classes;

const TAB = ^I;
	  CR = ^M;

procedure ListFileDir(Path: string; FileList: TStrings);
var
  SR: TSearchRec;
begin
  if AnsiLastChar( Path ) <> '\' then Path := Path + '\';

  if FindFirst(Path + '*.*', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr <> faDirectory) then
      begin
        FileList.Add(SR.Name);
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure ShowHelp;
begin
  Write(
    'mDir      iMproved Dir' + #13 + #10 +
    'Copyright (c) Rene Hickersberger' + #13 + #10 +
    '-------------------------------------------' + #13 + #10 +
    'Usage: mDir [options] [directory] [options]' + #13 + #10 +
    '' + #13 + #10 +
    'Options: --help       Show this help' + #13 + #10
  );
  halt;
end;

var files : TStringList;
    i:integer;
    dir:string;
begin
  WriteLn;
  dir := GetCurrentDir;

  for i := 0 to paramcount do
  begin
    if paramstr(i) = '--help' then ShowHelp
    else if DirectoryExists(paramstr(i)) then 
	  dir := paramstr(i);
  end;

	files := TStringList.Create;
	
	ListFileDir( dir, files );
	for i := 0 to files.count-1 do
	begin
		WriteLn(TAB + files.Strings[i]);
	end;
end.