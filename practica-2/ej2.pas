program ej2;

const valoralto=9999;

type
	registro_autor = record
		cod,cant:integer;
		nombre_autor,nombre_disco,genero:string[20];
	end;

	file_autores = file of registro_autor;

procedure crearArchivo();
var
	reg:registro_autor;
	archivo: file_autores;
begin
	assign(archivo, 'tmp/ej2/discografica');
	rewrite(archivo);

	writeln('Ingrese el nombre del autor: '); readln(reg.nombre_autor);
	while(reg.nombre_autor <> 'zzz') do
	begin
		writeln('Ingrese el nombre del disco: '); readln(reg.nombre_disco);
		writeln('Ingrese el genero: '); readln(reg.genero);
		writeln('Ingrese el codigo de autor: '); readln(reg.cod);
		writeln('Ingrese la cantidad de copias vendidas: '); readln(reg.cant);
		write(archivo, reg);
		writeln('Ingrese el nombre del autor '); readln(reg.nombre_autor);
	end;
	close(archivo);
	writeln('Archivo creado correctamente.');
end;

procedure leer(var archivo: file_autores; var dato:registro_autor);
begin
	if not eof(archivo) then read(archivo, dato)
	else dato.cod:=valoralto;
end;

var
	reg,aux: registro_autor;
	total,totalAutor,totalGenero:integer;
	archivo: file_autores;
begin
	crearArchivo();

	assign(archivo, 'tmp/ej2/discografica');
	reset(archivo);

	leer(archivo, reg);
	total:=0;

	while(reg.cod <> valoralto) do
	begin
		writeln('Autor: ', reg.nombre_autor);
		aux.cod := reg.cod;
		totalAutor := 0;

		while(aux.cod=reg.cod) do
		begin
			writeln('Genero: ', reg.genero);
			aux.genero := reg.genero;
			totalGenero := 0;

			while (aux.cod=reg.cod) and (aux.genero=reg.genero) do
			begin
				writeln('Nombre del disco: ',reg.nombre_disco);
				writeln('Cantidad vendida: ',reg.cant);
				totalGenero:=totalGenero+reg.cant;
				leer(archivo, reg);
			end;
			writeln('Total genero: ', totalGenero);
			totalAutor:=totalAutor+totalGenero;
		end;
			writeln('Total autor: ', totalAutor);
			total:=total+totalAutor;
	end;
	writeln('Total discografica: ', total);
	close(archivo);
end.


