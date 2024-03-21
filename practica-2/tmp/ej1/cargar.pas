program cargar;
Uses sysutils;

type
		str4=string[4];

		licencia = record
			cod:str4;
			fecha:string[6];
			cant:integer
		end;

		empleado = record
			cod:str4;
			nombre:string[20];
			apellido:string[20];
			fecha:string[6];
			direccion:string[20];
			telefono:integer;
			hijos:integer;
			cant:integer;
		end;

		detalle = file of licencia;
		maestro = file of empleado;

		arrayDetalles= array[1..10] of detalle;
		arrayLicencias= array[1..10] of licencia;

var
	regm: empleado;
	min:licencia;
	regd: arrayLicencias;
	det: arrayDetalles;
	mae: maestro;
	aux: str4;
	informe: text;
	i:integer;
begin
	assign(mae, 'maestro');
	rewrite(mae);


	for i:= 1 to 10 do
	begin
		assign(det[i], 'detalle'+IntToStr(i));
		rewrite(det[i]);
		writeln('CARGANDO MAESTRO - DETALLE',i);
		writeln('Nombre del empleado: '); readln(regm.nombre);
		while(regm.nombre<>'zzz') do
		begin
			writeln('Apellido del empleado: '); readln(regm.apellido);
			writeln('Codigo del empleado: '); readln(regm.cod);
			writeln('Fecha de nacimiento: '); readln(regm.fecha);
			writeln('Direccion: '); readln(regm.direccion);
			writeln('Dias de licencia disponibles: '); readln(regm.cant);
			writeln('Telefono: '); readln(regm.telefono);
			write(mae, regm);
			regd[i].cod:=regm.cod;
			regd[i].fecha:=regm.fecha;
			regd[i].cant:=regm.cant;
			write(det[i],regd[i]);
			writeln('CARGANDO MAESTRO - DETALLE', i);
			writeln('Nombre del empleado: '); readln(regm.nombre);
	end;
		close(det[i])
	end;
	close(mae);
end.
