create database EtapaProductiva;
use EtapaProductiva;
 
 /*Creacion de tabla para Almacenar Administradores*/
 
create table administrador (
ident_Admin char(12) primary key,
nombre_Admin varchar (30) default 'AdminPMW',
contrasenia varchar (255) not null
); 

/*Procedimiento de almacenado  para la tabla de Administrador*/
DELIMITER //
create procedure  InsertarAdministrador(
    in identificacion char(12),
    in nombre varchar(30),
    in contrasenia varchar(255)
)
begin
    declare  identificacion_existente INT;
    select count(*) into identificacion_existente from administrador where ident_Admin = identificacion;
    if identificacion_existente > 0 then
        signal sqlstate '45000'
        set message_text = 'La identificación ya existe en la tabla administrador.';
    else
        insert into administrador (ident_Admin, nombre_Admin, contrasenia)
        VALUES (identificacion, nombre, contrasenia);
     end if;
end //
DELIMITER ;

call  InsertarAdministrador ('123456', 'Alejandro', 'dndnwaqdqwd');



 
/*Creacion de tabla para Almacenar Tecnicos */
create table tecnico (
cod_Tecnico int auto_increment primary key,
nombre_Tecnico varchar(90)
);

-- Creacion de Procedimiento de almacenado para Tecnico

delimiter //
create procedure insertar_tecnico(
    in nombre varchar(90)
)
begin
    insert into tecnico (nombre_tecnico) values (nombre);
end //
delimiter ;


-- creacion tabla De Estudiante 
	
    create table estudiante (
	codigo_Est bigint auto_increment primary key,
    ident_Estudiante char (15) not null,
    primer_Nombre varchar (20) not null,
    segundo_Nombre varchar (20) default '',
    primer_Apellido varchar (20) not null,
    segundo_Apellido varchar (20) default '',
    telefono char (10),
	cod_Tecnico_Est int,
    foreign key (cod_Tecnico_Est) references tecnico (cod_Tecnico)
    );

-- Creacion de procediento de Estudiante con sus validaciones 

delimiter //
create procedure insertar_estudiante(
    in identificacion char(15),
    in primer_nombre varchar(20),
    in segundo_nombre varchar(20),
    in primer_apellido varchar(20),
    in segundo_apellido varchar(20),
    in telefono char(10),
    in cod_tecnico_est int
)
begin
    declare tecnico_existente int;
    declare estudiante_existente int;

    select count(*) into tecnico_existente from tecnico where cod_tecnico = cod_tecnico_est;

    select count(*) into estudiante_existente from estudiante where ident_estudiante = identificacion;

    if tecnico_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'El código de técnico no existe en la tabla "tecnico".';
    elseif estudiante_existente > 0 then
        signal sqlstate '45000'
        set message_text = 'La identificación del estudiante ya existe en la tabla "estudiante".';
    else
    
        insert into estudiante (ident_estudiante, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, cod_tecnico_est)
        values (identificacion, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, cod_tecnico_est);
    end if;
end //
delimiter ;

-- creacion de tablas de modalidades (contrato, pasantias,homologacion y proyecto)

create table contrato_Aprendizaje (
	cod_ContratoA int primary key
);

create table pasantias (
	cod_Pasantia int primary key
);

create table proyecto (
	cod_Proyecto int primary key
);

create table homologacion (
	cod_homolg int primary key
    );
    

-- Creacion de tabla Estudiante con Contrato de Aprendizaje

create table contrato_Estudiante (
cod_contrato_Es int primary key ,	
cod_Est_Cont bigint,
cod_ContratoA_Est int,
empresa_Vinculada varchar (90),
fecha_Incio datetime not null,
fecha_Final datetime null,
horarios varchar (100),
copia_Contrato boolean,
constancia boolean,
foreign key (cod_Est_Cont) references estudiante (codigo_Est),
foreign key (cod_ContratoA_Est) references contrato_Aprendizaje (cod_ContratoA)
);



-- Creacion de procedimiento de almacenado de Estudiante con Contrato de Aprendizaje
delimiter //
create procedure insertar_contrato_estudiante(
    in cod_contrato_es int,
    in cod_est_cont bigint,
    in cod_contratoa_est int,
		in empresa_vinculada varchar(90),
    in fecha_inicio datetime,
    in fecha_final datetime,
    in horarios varchar(100),
    in copia_contrato boolean,
    in constancia boolean
)
begin
    declare estudiante_existente int;
    declare contratoa_est_existente int;

    select count(*) into estudiante_existente from estudiante where codigo_est = cod_est_cont;

    select count(*) into contratoa_est_existente from contrato_aprendizaje where cod_contratoa = cod_contratoa_est;

    if estudiante_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'El código de estudiante no existe en la tabla "estudiante".';
    elseif contratoa_est_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'El código de contrato de aprendizaje no existe en la tabla "contrato_aprendizaje".';
    else
        insert into contrato_estudiante (cod_contrato_es, cod_est_cont, cod_contratoa_est, empresa_vinculada, fecha_inicio, fecha_final, horarios, copia_contrato, constancia)
        values (cod_contrato_es, cod_est_cont, cod_contratoa_est, empresa_vinculada, fecha_inicio, fecha_final, horarios, copia_contrato, constancia);
    end if;
end //
delimiter ;


-- Creacion de procedimiento de almacenado para actualizar contrato Con Estudiante 

delimiter //
create procedure actualizar_contrato_estudiante(
    in cod_contrato_es_ant int, 
    in cod_est_cont int,         
    in cod_contratoa_est int,     
    in empresa_vinculada varchar(90),
    in fecha_inicio datetime,
    in fecha_final datetime,
    in horarios varchar(100),
    in copia_contrato boolean,
    in constancia boolean
)
begin
    declare estudiante_existente int;
    declare contratoa_est_existente int;

    select count(*) into estudiante_existente from estudiante where codigo_est = cod_est_cont;

    select count(*) into contratoa_est_existente from contrato_aprendizaje where cod_contratoa = cod_contratoa_est;

    if estudiante_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'El nuevo código de estudiante no existe en la tabla "estudiante".';
    elseif contratoa_est_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'El nuevo código de contrato de aprendizaje no existe en la tabla "contrato_aprendizaje".';
    else
        update contrato_estudiante
        set cod_est_cont = cod_est_cont,
            cod_contratoa_est = cod_contratoa_est,
            empresa_vinculada = empresa_vinculada,
            fecha_inicio = fecha_inicio,
            fecha_final = fecha_final,
            horarios = horarios,
            copia_contrato = copia_contrato,
            constancia = constancia
        where cod_contrato_es = cod_contrato_es_ant;
    end if;
end //
delimiter ;


create table  citas_Seguimiento_Contrato (
cod_Cita_Cont int primary key auto_increment,
fecha_Realizada datetime,
responsable_Cita varchar (50) not null,
Estado boolean,
nota float,
cod_Cita_Est bigint, 
foreign key (cod_Cita_Est) references contrato_Estudiante (cod_Est_Cont)

);


--  procedimientos de almacenado de cita Contrato

delimiter //
create procedure insertar_cita_seguimiento_contrato(
    in fecha_realizada datetime,
    in responsable_cita varchar(50),
    in estado boolean,
    in nota float,
    in cod_cita_est bigint
)
begin
    declare contrato_existente int;

    select count(*) into contrato_existente from contrato_estudiante where cod_est_cont = cod_cita_est;

    if contrato_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'el código de contrato de estudiante no existe en la tabla "contrato_estudiante".';
    else
        insert into citas_seguimiento_contrato (fecha_realizada, responsable_cita, estado, nota, cod_cita_est)
        values (fecha_realizada, responsable_cita, estado, nota, cod_cita_est);
    end if;
end //
delimiter ;











-- Creacion de la tabla de Homologacion Para Estudiante 

create table homologacion_Estudiante (
 cod_homolog_Est int auto_increment, 
 empresa_Homolog varchar (60) not null,
 fecha_Homolog datetime ,
 estado_Homomlogacion boolean,
 observaciones_Homolog varchar (300),
 cod_Est_Homolog bigint,
 cod_Homolog_Est int ,
 foreign key (cod_Est_Homolog) references estudiante (cod_Est),
 foreign key (cod_Homolog_Est) references homologacion (cod_homolg)
);


-- creacion del procedimiento de almacenado de homogacion con Estudiante 
delimiter //
create procedure insertar_homologacion_estudiante(
    in empresa_homolog varchar(60),
    in fecha_homolog datetime,
    in estado_homologacion boolean,
    in observaciones_homolog varchar(300),
    in cod_est_homolog bigint,
    in cod_homolog_est int
)
begin
    declare estudiante_existente int;
    declare homologacion_existente int;
    select count(*) into estudiante_existente from estudiante where codigo_est = cod_est_homolog;
    select count(*) into homologacion_existente from homologacion where cod_homolg = cod_homolog_est;

    if estudiante_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'El código de estudiante no existe en la tabla "estudiante".';
    elseif homologacion_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'El código de homologación no existe en la tabla "homologacion".';
    else
        insert into homologacion_estudiante (empresa_homolog, fecha_homolog, estado_homologacion, observaciones_homolog, cod_est_homolog, cod_homolog_est)
        values (empresa_homolog, fecha_homolog, estado_homologacion, observaciones_homolog, cod_est_homolog, cod_homolog_est);
    end if;
end //
delimiter ;



-- Creacion del procedimiento de actualizar homologacion de Estudiante

delimiter //
create procedure actualizar_homologacion_estudiante(
    in cod_homolog_est_ant int,  
    in empresa_homolog varchar(60),
    in fecha_homolog datetime,
    in estado_homologacion boolean,
    in observaciones_homolog varchar(300),
    in cod_est_homolog bigint,
    in cod_homolog_est int
)
begin
    declare estudiante_existente int;
    declare homologacion_existente int;
    select count(*) into estudiante_existente from estudiante where codigo_est = cod_est_homolog;
    select count(*) into homologacion_existente from homologacion where cod_homolg = cod_homolog_est;

    if estudiante_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'El nuevo código de estudiante no existe en la tabla "estudiante".';
    elseif homologacion_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'El nuevo código de homologación no existe en la tabla "homologacion".';
    else	
        update homologacion_estudiante
        set empresa_homolog = empresa_homolog,
            fecha_homolog = fecha_homolog,
            estado_homologacion = estado_homologacion,
            observaciones_homolog = observaciones_homolog,
            cod_est_homolog = cod_est_homolog,
            cod_homolog_est = cod_homolog_est
        where cod_homolog_est = cod_homolog_est_ant;
    end if;
end //
delimiter ;





-- Creacion de Pasantias


create table pasantias_Estudiante (
	cod_Pasantia_Est int primary key auto_increment,
    fecha_Inicio datetime,
    fecha_Final datetime,
    Empresa_Vinculada varchar (100),
    Horas_Realizadas bigint, 
    horario varchar (150),
    documentacion boolean,
    constancia_Pasantia boolean,
    carta_Presentacion boolean, 
    arl boolean,
    acuerdo_Pasantia boolean,
    planilla boolean,
    cod_Pas_Est bigint,
    cod_pasantia int,
    foreign key (cod_Pas_Est) references estudiante (codigo_Est),
    foreign key (cod_pasantia) references pasantias (cod_Pasantia)
    );
    
    
    -- procedimeitno de insertar de pasantias con estudiante 
    
    delimiter //
create procedure insertar_pasantia_estudiante(
    in fecha_inicio datetime,
    in fecha_final datetime,
    in empresa_vinculada varchar(100),
    in horas_realizadas bigint,
    in horario varchar(150),
    in documentacion boolean,
    in constancia_pasantia boolean,
    in carta_presentacion boolean,
    in arl boolean,
    in acuerdo_pasantia boolean,
    in planilla boolean,
    in cod_pas_est bigint,
    in cod_pasantia int
)
begin
    declare estudiante_existente int;
    declare pasantia_existente int;

    -- Verificar si el código de estudiante existe en la tabla "estudiante"
    select count(*) into estudiante_existente from estudiante where codigo_est = cod_pas_est;

    -- Verificar si el código de pasantía existe en la tabla "pasantias"
    select count(*) into pasantia_existente from pasantias where cod_pasantia = cod_pasantia;

    if estudiante_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'El código de estudiante no existe en la tabla "estudiante".';
    elseif pasantia_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'El código de pasantía no existe en la tabla "pasantias".';
    else
        -- Insertar la nueva pasantía de estudiante en la tabla "pasantias_estudiante"
        insert into pasantias_estudiante (fecha_inicio, fecha_final, empresa_vinculada, horas_realizadas, horario, documentacion, constancia_pasantia, carta_presentacion, arl, acuerdo_pasantia, planilla, cod_pas_est, cod_pasantia)
        values (fecha_inicio, fecha_final, empresa_vinculada, horas_realizadas, horario, documentacion, constancia_pasantia, carta_presentacion, arl, acuerdo_pasantia, planilla, cod_pas_est, cod_pasantia);
    end if;
end //
delimiter ; 

-- Procedimiento para actualizar pasantia con Estudianbte 

delimiter //
create procedure actualizar_pasantia_estudiante(
    in cod_pasantia_est int,
    in fecha_inicio datetime,
    in fecha_final datetime,
    in empresa_vinculada varchar(100),
    in horas_realizadas bigint,
    in horario varchar(150),
    in documentacion boolean,
    in constancia_pasantia boolean,
    in carta_presentacion boolean,
    in arl boolean,
    in acuerdo_pasantia boolean,
    in planilla boolean,
    in cod_pas_est bigint,
    in cod_pasantia int
)
begin
    declare estudiante_existente int;
    declare pasantia_existente int;

    -- Verificar si el código de estudiante existe en la tabla "estudiante"
    select count(*) into estudiante_existente from estudiante where codigo_est = cod_pas_est;

    -- Verificar si el código de pasantía existe en la tabla "pasantias"
    select count(*) into pasantia_existente from pasantias where cod_pasantia = cod_pasantia;

    if estudiante_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'el código de estudiante no existe en la tabla "estudiante".';
    elseif pasantia_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'el código de pasantía no existe en la tabla "pasantias".';
    else
        -- Actualizar la pasantía de estudiante en la tabla "pasantias_estudiante"
        update pasantias_estudiante
        set fecha_inicio = fecha_inicio,
            fecha_final = fecha_final,
            empresa_vinculada = empresa_vinculada,
            horas_realizadas = horas_realizadas,
            horario = horario,
            documentacion = documentacion,
            constancia_pasantia = constancia_pasantia,
            carta_presentacion = carta_presentacion,
            arl = arl,
            acuerdo_pasantia = acuerdo_pasantia,
            planilla = planilla,
            cod_pas_est = cod_pas_est,
            cod_pasantia = cod_pasantia
        where cod_pasantia_est = cod_pasantia_est;
    end if;
end //
delimiter ;




    
    create table  citas_Seguimiento_Pasantia (
cod_Cita_Cont int primary key auto_increment,
fecha_Realizada datetime,
responsable_Cita varchar (50) not null,
Estado boolean,
nota float,
 cod_Pas_Est bigint, 
foreign key (cod_Pas_Est) references pasantias_Estudiante (cod_Pas_Est)

);

-- Procedimietno de almacenado de citas_Pasanias

delimiter //
create procedure insertar_cita_seguimiento_pasantia(
    in fecha_realizada datetime,
    in responsable_cita varchar(50),
    in estado boolean,
    in nota float,
    in cod_pas_est bigint
)
begin
    declare estudiante_existente int;

    -- Verificar si el código de pasantía de estudiante existe en la tabla "pasantias_estudiante"
    select count(*) into estudiante_existente from pasantias_estudiante where cod_pas_est = cod_pas_est;

    if estudiante_existente = 0 then
        signal sqlstate '45000'
        set message_text = 'el código de pasantía de estudiante no existe en la tabla "pasantias_estudiante".';
    else
        -- Insertar una nueva cita de seguimiento en la tabla "citas_seguimiento_pasantia"
        insert into citas_seguimiento_pasantia (fecha_realizada, responsable_cita, estado, nota, cod_pas_est)
        values (fecha_realizada, responsable_cita, estado, nota, cod_pas_est);
    end if;
end //
delimiter ;













    
    
    
    
    





















 




