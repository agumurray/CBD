program ej6;

type
	registro_maestro = record
		cod:integer;
		fecha:string[6];
		monto:real;
	end;

	registro_compacto = record
		cod:integer;
		monto:real;
	end;

	file_registro_maestro = file of registro_maestro;
	file_registro_compacto = file of registro_compacto;

procedure crearArchivo();
var
	regm: registro_maestro;
	master:file_registro_maestro;
begin
	assign(master, 'tmp/ej6/maestro'); rewrite(master);

	writeln('Ingrese los datos de cada servicio: ');
	write('Codigo de mozo: '); readln(regm.cod);
	while(regm.cod<>9999) do
	begin
		write('Fecha de servicio: '); readln(regm.fecha);
		write('Monto recaudado: '); readln(regm.monto);
		write(master, regm);
		write('Codigo de mozo: '); readln(regm.cod);
	end;
	close(master);
end;

procedure compactar(var master: file_registro_maestro; var compact:file_registro_compacto);
var
	regm, aux:registro_maestro;
	regc:registro_compacto;
	montoTotal:real;
begin
	assign(master, 'tmp/ej6/maestro'); reset(master);
	assign(compact, 'tmp/ej6/compacto'); rewrite(compact);

	if not eof(master) then read(master, regm);
	while not eof(master) do
	begin
		aux.cod:=regm.cod;
		montoTotal:=0;
		while (not eof(master)) and (aux.cod = regm.cod) do
		begin
			montoTotal:=montoTotal+regm.monto;
			read(master, regm);
		end;
		regc.cod:=aux.cod;
		regc.monto:=montoTotal;
		write(compact, regc);

		if (eof(master)) then
		begin
			if (aux.cod=regm.cod) then
			begin
				regc.monto:=regc.monto+regm.monto;
				seek(compact, filepos(compact)-1); write(compact, regc);
			end
			else
			begin
				regc.cod:=regm.cod;
				regc.monto:=regm.monto;
				write(compact, regc);
			end;
		end;
	end;
	close(master);
	close(compact);
end;

var
	master:file_registro_maestro;
	compact:file_registro_compacto;
	regc:registro_compacto;
begin
	crearArchivo();
	compactar(master, compact);
	assign(compact,'tmp/ej6/compacto'); reset(compact);
	writeln('Codigo Monto');
	while not eof(compact) do
	begin
		read(compact, regc);
		writeln(regc.cod, ' ', regc.monto:2:2);
	end;
	close(compact);
end.
