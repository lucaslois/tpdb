## CalcularDemoraResolucion (FUNCTION)
Dado el ID de un ticket, determina el tiempo que tardó en ser resuelto. En caso de que el ticket no haya sido resuelto aun devolverá 0.

Input:
* @idTicket (int)

Output: 
* Tiempo que tardó en resolverse expresado en horas (int)

## CambiarEstodoDeTicket (PROCEDURE)

Dado el ID de un Ticket y el ID de un nuevo estado, actualiza dicho estado siguiendo las reglas del diagrama de flujo.

![Alt text](./images/flujo_estados.png)

Input: 
* @idTicket (int)
* @idEstado (varchar(2))

Output:
| ErrorCode | ErrorMessage                                                                                       |
|-----------|----------------------------------------------------------------------------------------------------|
| 1         | El ID del ticket es invalido                                                                       |
| 2         | El ID del estado es invalido                                                                       |
| 3         | Si el ticket esta "Abierto", solo se mueve mover a "En Progreso"                                   |
| 4         | Si el ticket esta "En Progreso", solo se puede mover a "Resuelto", "Pendiente Cliente" o "Cerrado" |
| 5         | Si el ticket esta "Pendiente Cliente", solo se puede mover a "En Progreso"                         |


Notas:
* El store procedure actualizara la fecha de resolucion en caso de que el ticket sea movido a estado _Resuelto_.
* El store procedure actualizara la fecha de cierre en caso de que el ticket sea movido a estado _Cerrado_.
* Este proceso crea un registro en la tabla `HistoriaLEstados` indicando el cambio.

## CrearCliente (PROCEDURE)

Crea un cliente como prospecto dentro de la base de datos.

Input: 
* @nombre (varchar(255))
* @apellido (varchar(255))
* @tipoDocumento (varchar(25))
* @nroDocumento (varchar(255))
* @fechaNacimiento (date) (optional)
* @email (varchar(255)) (optional)

Output:
| idCliente                               | ErrorCode | ErrorMessage                                            |
|-----------------------------------------|-----------|---------------------------------------------------------|
| Retorna el id del cliente recien creado |           |                                                         |
|                                         | 1         | El nombre, apellido, tipodoc y nrodoc son obligatorios  |
|                                         | 2         | El email posee un formato invalido                      |
|                                         | 3         | Ya existe un cliente con esa combinacion tipodoc/nrodoc |

Notas:
* Fecha y Email son opcionales
* En caso que el mail sea enviado debe poseer formato valido
* Tipo y Nro de documento sean validos y no existe cliente con esa combinacion.

## CrearServicio (PROCEDURE)

Crea un servicio para un cliente en la base de datos.

Input:
* @idTipoServicio (char(2))
* @idCliente (int)
* @telefono (int)
* @calle (varchar(255))
* @altura (int)
* @piso (int)
* @depto (varchar(5))

Output:
| idTicket                                 | ErrorCode | ErrorMessage                   |
|------------------------------------------|-----------|--------------------------------|
| Retorna el Nro de Servicoo recien creado |           |                                |
|                                          | 1         | El tipo de servicio no existee |
|                                          | 2         | El cliente no existe           |
|                                          | 3         | La direccion es obligatoria    |

Notas:
* La fecha de inicio del servicio se establece automáticamente como la fecha actual.
* El estado inicial del servicio es 'AC' (Activo).
* El tipo de servicio debe existir en la base de datos.
* El cliente debe existir en la base de datos.
* La direccion es obligatoria.
* Si el cliente no está activo, este pasa a estado activo.


## CrearTicket (PROCEDURE)

Crea un nuevo ticket para un servicio en la base de datos.

Input:
* @idTipologia (VARCHAR(2))
* @nroServicio (INT)
* @login (VARCHAR(255))
* @idCliente (INT))

Output:
| idTicket                               | ErrorCode | ErrorMessage                                  |
|----------------------------------------|-----------|-----------------------------------------------|
| Retorna el ID del Ticket recien creado |           |                                               |
|                                        | 1         | El Nro de servicio no existe                  |
|                                        | 2         | El Nro de Servicio no le pertenece al cliente |
|                                        | 3         | Debe proporcionarse una direccion valida      |
|                                        | 4         | La tipologia no existe                        |
|                                        | 5         | El cliente no existe                          |
|                                        | 6         | El login de empleado no existe                |                  |

Notas:
* La fecha de apertura del ticket se establece automáticamente como la fecha actual.
* El estado inicial del ticket es 'AB' (Abierto).
* Al crear un ticket se creará un registro en la tabla `HistorialEstados` reflejando la creacion.
* La tipologia debe ser valida.
* El Nro de Servicio debe ser valido.
* El numero de servicio debe pertenecer al cliente.
* El login del empleado debe ser valido.

## EditarCliente (PROCEDURE)

Edita la información de un cliente en la base de datos.

Input:
* @idCliente (INT)
* @nombre (VARCHAR(255))
* @apellido (VARCHAR(255))
* @fechaNacimiento (DATE)
* @email (VARCHAR(255))

Output:
| ErrorCode | ErrorMessage                          |
|-----------|---------------------------------------|
| 1         | El cliente se encuentra activo        |
| 2         | El email tiene un formato invalido    |
| 3         | El nombre y apellido son obligatorios |
| 4         | El cliente no existe                  |

Notas:
* La edición de la información incluye el nombre, apellido y fecha de nacimiento del cliente.
* Solo se permite editar clientes que no estén activos.

## ExistetTipologiaParaServicio (FUNCTION)

Verifica la existencia de una tipología para un servicio específico en la base de datos.

Input:
* @nroServicio (INT)
* @idTipologia (VARCHAR(2))

Output:
* Retorna un valor bit (0 o 1) indicando si existe o no una tipología para el servicio proporcionado.

Notas:
* La función utiliza la tabla 'ServiciosContratados' para obtener el 'IdServicio' correspondiente al 'NroServicio' proporcionado.
* Luego, verifica en la tabla 'SLA' si hay alguna entrada que coincida con el 'IdServicio' y la 'IdTipologia'.
* Si encuentra al menos una coincidencia, establece el valor de retorno como 1, indicando que la tipología existe para el servicio.

## InactivarServicio (PROCEDURE)

Inactiva un servicio en la base de datos.

Input:
* @idServicio (INT)

Output:
| ErrorCode | ErrorMessage                          |
|-----------|---------------------------------------|
| 1         | El servicio no existe                 |

Acciones:
* Actualiza el estado del servicio (en la tabla 'ServiciosContratados') a 'IN' (Inactivo).
* Verifica la cantidad de servicios activos para el cliente asociado al servicio inactivado.
* Si la cantidad de servicios activos para ese cliente es cero, actualiza el estado del cliente (en la tabla 'Clientes') a 'IN' (Inactivo).

## ReasignarTicket (PROCEDURE)

Reasigna un ticket a un cliente específico en la base de datos.

Input:
* @idTicket (INT)
* @login (VARCHAR(255))

Output:
| ErrorCode | ErrorMessage                          |
|-----------|---------------------------------------|
| 1         | El Ticket no existe                   |
| 2         | El empleado no existe                 |

Acciones:
* Actualiza el campo 'IdCliente' en la tabla 'Tickets' con el nuevo valor proporcionado para el ticket especificado.

## ValidarFechaMayorEdad (FUNCTION)

Valida si la fecha de nacimiento proporcionada corresponde a una persona mayor de 18 años.

Input:
* @fechaNacimiento (DATE)

Output:
* Retorna un valor bit (0 o 1) indicando si la persona es mayor de 18 años o no.

Notas:
* La función utiliza la función DATEDIFF para calcular la diferencia en años entre la fecha de nacimiento proporcionada y la fecha actual.
* Si la diferencia es mayor que 18, se establece el valor de retorno como 1, indicando que la persona es mayor de edad.