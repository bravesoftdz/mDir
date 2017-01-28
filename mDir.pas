{ MDir - iMproved Dir }
{  Made by René Hickersberger }

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
		'Options:	--help       Show this help' + #13 + #10 + 
		'        	-i           Show information like size of the file' + #13 + #10
	);
	halt;
end;

var	files	:	TStringList;
	i		:	integer;
	dir		:	string;
	info	:	boolean;
	age		:	TDateTime;
begin
	WriteLn;
	dir := GetCurrentDir;

	info := false;
	for i := 1 to paramcount do
	begin
		if DirectoryExists(paramstr(i)) then 
			dir := paramstr(i)
		else if paramstr(i) = '-i' then
			info := true
		else
			ShowHelp;
	end;
	
	if AnsiLastChar(dir) <> '\' then dir := dir + '\';

	files := TStringList.Create;
	
	ListFileDir( dir, files );
	for i := 0 to files.count-1 do
	begin
		if info then
		begin
			if DirectoryExists(dir + files.Strings[i]) then
			begin
				WriteLn(TAB + TAB + TAB + TAB + '<DIR>' + TAB + files.Strings[i]);
			end else
			begin
				age := FileDateToDateTime(FileAge(dir + files.Strings[i]));
				WriteLn(DateTimeToStr(age) + TAB + TAB + files.Strings[i]);
			end;
		end else
			WriteLn(TAB + TAB + files.Strings[i]);
	end;
end.
