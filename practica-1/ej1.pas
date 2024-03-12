program ej1;

var
	materialName, fileName: string;
	logicFile: text;
begin
	write('Please enter the file name: ');
	readln(fileName);
	fileName := Concat('tmp/', fileName);
	assign(logicFile,fileName);
	rewrite(logicFile);

  repeat
		write('Enter the material name: ');
		readln(materialName);
		writeln(logicFile, materialName);
	until materialName = 'cemento';

	close(logicFile);
end.




