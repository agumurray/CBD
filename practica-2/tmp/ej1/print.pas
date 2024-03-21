program print;

type
	str4 = string[4];

	registro_maestro = record
		cod:str4;
		fecha:string[6];
		nombre,apellido,direccion:string[20];
		telefono,hijos,cant:integer;
	end;

	file_maestro=file of registro_maestro;

var
	regm:registro_maestro;
	mae:file_maestro;
begin
	assign(mae, 'maestro');
	reset(mae);
	while(not eof(mae)) do
	begin
		read(mae, regm);
		writeln('Codigo de empleado: ', regm.cod);
		writeln('Cantidad de vacaciones: ', regm.cant);
	end;

	close(mae);
end.
