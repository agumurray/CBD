program ej5;

const valoralto='9999';

type
	registro_maestro = record
		partido,localidad,barrio:string[20];
		cantNinios,cantAdultos: integer;
	end;

	file_registro_maestro = file of registro_maestro;


procedure crearArchivo();
var
	reg:registro_maestro;
	archivo: file_registro_maestro;
begin
	assign(archivo, 'tmp/ej5/municipios');
	rewrite(archivo);

	writeln('Partido: '); readln(reg.partido);
	while(reg.partido<>'zzz')do
	begin
		writeln('Localidad: '); readln(reg.localidad);
		writeln('Barrio: '); readln(reg.barrio);
		writeln('Cantidad de ninios: '); readln(reg.cantNinios);
		writeln('Cantidad de adultos: '); readln(reg.cantAdultos);
		write(archivo, reg);
		writeln('Partido: '); readln(reg.partido);
	end;
	close(archivo);
	writeln('Archivo creado correctamente.');
end;

procedure leer(var archivo: file_registro_maestro; var dato: registro_maestro);
begin
	if not eof(archivo) then read(archivo, dato)
	else dato.partido:=valoralto;
end;

var
	reg, aux: registro_maestro;
	totalNiniosPartido, totalAdultosPartido,
	totalNiniosLoc, totalAdultosLoc:integer;
	archivo: file_registro_maestro;
begin
	crearArchivo();

	assign(archivo, 'tmp/ej5/municipios');
	reset(archivo);

	leer(archivo, reg);

	while(reg.partido <> valoralto) do
	begin
		writeln('Partido: ', reg.partido);
		aux.partido:=reg.partido;
		totalNiniosPartido:=0; totalAdultosPartido:=0;

		while(aux.partido = reg.partido) do
		begin
			writeln('Localidad: ', reg.localidad);
			aux.localidad:=reg.localidad;
			totalNiniosLoc:=0; totalAdultosLoc:=0;

			while(aux.partido=reg.partido) and (aux.localidad=reg.localidad) do
			begin
				writeln('Barrio: ', reg.barrio, ' cantidad de ninios: ', reg.cantNinios);
				writeln('Barrio: ', reg.barrio, ' cantidad de adultos: ', reg.cantAdultos);
				totalNiniosLoc:=totalNiniosLoc+reg.cantNinios;
				totalAdultosLoc:=totalAdultosLoc+reg.cantAdultos;
				leer(archivo,reg);
			end;
      writeln('Total ninios localidad: ',totalNiniosLoc);
			writeln('Total adultos localidad: ',totalAdultosLoc);
			totalNiniosPartido:=totalNiniosPartido+totalNiniosLoc;
			totalAdultosPartido:=totalAdultosPartido+totalAdultosLoc;
		end;
		writeln('Total ninios partido: ', totalNiniosPartido);
		writeln('Total adultos partido: ', totalAdultosPartido);
	end;
	close(archivo);
end.
