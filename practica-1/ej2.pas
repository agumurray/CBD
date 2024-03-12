program ej2;

type
	finteger= file of integer;

var
	carga: finteger;
  min, max, n: integer;
	filename: string;
begin
	write('Please enter the file name: ');
	readln(filename);
	filename := Concat('tmp/', filename);
	assign(carga, filename);
	reset(carga);

	min := 9999;
	max := 0;


	while not eof(carga) do
	begin
		read(carga, n);
		writeln('El numero actual de votantes es: ', n);
		if (n < min) then
			min := n;
		if (n > max) then
			max := n;
	end;
	close(carga);
	writeln('La cantidad minima de votantes es: ', min);
	writeln('La cantidad maxima de votantes es: ', max);
end.

