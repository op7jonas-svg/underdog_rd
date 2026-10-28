# Surteme: cómo dejar la página lista (se hace una sola vez)

Página: https://op7jonas-svg.github.io/underdog_rd/surteme/

## 1. Crear la cuenta gratis
1. Entra a https://supabase.com y pulsa **Start your project**. Regístrate (puedes usar tu cuenta de GitHub o tu correo).
2. Pulsa **New project**.
   - **Name:** `surteme`
   - **Database Password:** inventa una contraseña y guárdala (casi nunca la vas a necesitar).
   - **Region:** `East US` (la más cerca de RD).
   - Plan: **Free**.
3. Pulsa **Create new project** y espera 1 o 2 minutos.

## 2. Preparar el archivador
1. En el menú de la izquierda entra a **SQL Editor**.
2. Abre el archivo `setup.sql` (está en esta misma carpeta), copia todo el texto, pégalo y pulsa **Run**.
3. Debe salir "Success". Si sale un aviso de confirmación, acéptalo.

## 3. Crear los usuarios (tú y tu esposa)
1. Menú izquierdo: **Authentication** → **Users** → **Add user** → **Create new user**.
2. Pon el correo y una contraseña. Marca **Auto Confirm User**. Pulsa **Create user**.
3. Repite para tu esposa.
4. Para que nadie más pueda registrarse: **Authentication** → **Sign In / Providers** → apaga **Allow new users to sign up** → **Save**.

## 4. Conectar la página
1. Pulsa el botón **Connect** (arriba) o ve a **Project Settings** → **API Keys**.
2. Copia estos dos datos:
   - **Project URL** (empieza con `https://` y termina en `.supabase.co`)
   - **Publishable key** (empieza con `sb_publishable_`) o, si no aparece, la **anon public key**
3. Pégalos en `config.js`, o mándaselos a Claude para que los ponga.
   Estos dos datos se pueden compartir sin problema. **Nunca** compartas la **secret key** ni la **service_role key**.

## Bueno saber
- Todo es gratis: unos 500 MB de datos y 1 GB de archivos (más o menos 1,000 a 2,000 facturas en PDF).
- Si nadie usa la página en 7 días, Supabase la pone "en pausa". No se pierde nada: entras a supabase.com y pulsas **Restore project**.
- En el teléfono puedes poner la página como si fuera una app: ábrela en el navegador → **Compartir** → **Agregar a pantalla de inicio**.
- Si ya escribiste algo en una ventana (un cliente, un abono, un gasto, una cotización…) y tocas fuera de ella o pulsas **atrás**, la página pregunta **¿Salir sin guardar?** para que no pierdas lo escrito. Los botones **Cancelar** y **×** cierran sin preguntar.
- El botón **Salir** pregunta antes, y solo cierra la sesión en ese teléfono: los demás teléfonos y la computadora siguen dentro. Al salir se borra la contraseña: para volver a entrar hay que escribirla otra vez. Aun así, lo mejor es que cada uno tenga su propio usuario (paso 3).
- Con una ventana abierta, los avisos (verdes o rojos) salen arriba, para no tapar los botones **Guardar** y **Borrar**.
- **Los dos teléfonos se ven al día solos.** Lo que anota uno (una venta, un pago, una factura, un cliente…) aparece en el otro en un par de segundos, sin recargar. Si lo que tenías abierto era una ventana con algo escrito, lo escrito no se toca: solo se ponen al día las listas y los totales. Al volver a la app (o cuando vuelve el internet) también se cargan los datos otra vez, y si hay una versión nueva de la página se actualiza sola (nunca con una ventana abierta o algo a medio escribir: espera a la próxima vez).
- **Si los dos cambian lo mismo a la vez:** al guardar un cliente, una factura, un precio, un suplidor o una cotización que ya existía, solo se guarda lo que cambiaste tú. Si mientras tenías la ventana abierta el otro teléfono cambió otra cosa del mismo registro (por ejemplo, el teléfono del cliente o la nota de la cotización), eso no se borra.
- **Sin internet:** si los datos no se pudieron cargar, arriba sale un aviso rojo fijo con el botón **Reintentar**, y los totales salen con **—** (no un RD$0.00 que parece real). Mientras tanto no deja crear clientes, facturas ni cotizaciones (saldrían repetidos o con un número ya usado), ni abrir **Datos de mi empresa** (saldría vacío y al guardar se borrarían tu teléfono, RNC y dirección). Cuando vuelve el internet carga solo, y también al guardar algo con el internet ya de vuelta. Si el aviso dice **No se pudieron actualizar tus datos**, lo que ves es de antes: puede no estar al día.
- Si una foto o un PDF no sube (por ejemplo, con mala señal), el abono, la factura o el gasto igual quedan guardados y la página te lo dice. Pulsa **Guardar** otra vez para subir el archivo: no se anota dos veces. Si se va el internet justo al anotar la foto, la página revisa si quedó guardada: si quedó, sigue como si nada; si no lo puede saber, te avisa «no se sabe si el archivo quedó guardado» y no borra nada. Pulsa **Guardar** otra vez (queda una sola foto) o, si cierras la ventana, mira después si sale el 📎. Tocar **Guardar** dos veces seguidas tampoco crea clientes, suplidores ni precios repetidos. Si se va el internet justo al guardar una factura nueva, la página revisa si quedó guardada: si quedó, te la muestra; si no, pulsa **Guardar** otra vez (no sale repetida).

## Clientes
- **Borrar un cliente:** solo se puede si no tiene nada guardado. Si ya tiene facturas, pagos, cotizaciones o ventas, el botón dice **Archivar**: el cliente deja de salir en la lista y al elegir cliente, pero sus facturas, pagos y ventas se quedan guardados (y las ventas de meses pasados no cambian).
- Para ver los archivados, marca **Ver archivados** en la pestaña **Clientes**. Para volver a usar uno, ábrelo y pulsa **Activar**.

## Suplidores (comparar precios)
- Pestaña **Suplidores**. La primera vez te pedirá pegar un texto en **SQL Editor** (el mismo botón **Copiar texto** te lo da) y luego pulsar **Cargar precios de la plantilla**.
- Todo se compara con ITBIS y por unidad, igual que la plantilla de Excel.
- Para buscar un producto (aquí o en **+ De mi lista de precios** de una cotización) puedes escribir varias palabras, por ejemplo «funda 51». Al elegir producto salen primero los que lo dicen en el nombre.
- Toca un producto para ver todos los precios, editarlos o pasarlos a la calculadora.
- En **Mis suplidores** puedes indicar si cada suplidor cotiza con o sin ITBIS.

## Gastos y combustible
- Pestaña **Gastos**. La primera vez te pedirá pegar un texto en **SQL Editor** (botón **Copiar texto**).
- **Mis gastos:** anota cada gasto (combustible, peajes, sueldos, alquiler, etc.) con foto del recibo. Ves el total del mes y la **ganancia real** (lo que ganaste en tus ventas y facturas menos los gastos). Solo cuentan las ventas y facturas que tienen **lo que te costó**; si falta en alguna, la página te avisa.
- **Calcular combustible:** distancia, cuánto rinde el vehículo y precio del galón → cuánto cuesta el viaje y cuánto por entrega.
- Si en cada tanqueada anotas galones y kilometraje, la página calcula sola cuánto rinde tu vehículo.

## Abonos y cobros por WhatsApp
- La primera vez, en **Facturas** te pedirá pegar un texto en **SQL Editor** (botón **Copiar texto**).
- Abre una factura → **+ Agregar abono**: cuánto pagó, fecha, cómo pagó y foto del comprobante. La factura queda **Pendiente**, **Abonada** (dice cuánto falta) o **Pagada** sola. Si borras un abono o le bajas el monto, o le subes el total a una factura que ya estaba pagada, vuelve sola a **Pendiente** con lo que falta. Si en ese momento no hay internet para ponerla en **Pendiente**, el abono no se borra ni se cambia (la página te avisa y lo intentas otra vez): así una factura nunca queda **Pagada** mientras te deben.
- **Recordar pago por WhatsApp** (en el cliente o en la factura): abre WhatsApp con el mensaje listo, solo con lo que falta. Tú pulsas **Enviar**. Antes de abrirlo, la página revisa en la base los pagos de ese cliente (por si el otro teléfono acaba de anotar uno): si ya pagó todo, no manda nada y te avisa. Sin internet no lo manda.
- Si cambias algo de una factura (por ejemplo, la nota o los productos), solo se guarda lo que cambiaste: si mientras tanto el otro teléfono la marcó **Pagada**, sigue pagada.
- El cliente necesita tener su teléfono guardado.

## Cotizaciones y facturas con el diseño de Surteme
- La primera vez, en **Cotizaciones** te pedirá pegar un texto en **SQL Editor** (botón **Copiar texto**).
- **Datos de mi empresa:** teléfono, RNC, dirección, etc. Salen al pie de cada documento. El mensaje **¡Gracias por preferirnos!** sale siempre (puedes cambiar el texto); si no lo quieres, marca **No mostrar mensaje al pie**.
- **+ Nueva cotización:** eliges el cliente y agregas productos (de tu lista de precios o escritos a mano). El número (001-2026, 002-2026…) se pone solo. Si desde el otro teléfono ya se usó ese número, la página usa el siguiente libre y te avisa cuál quedó.
- **Compartir imagen (WhatsApp)**, **PDF** o **Imprimir**.
- **Convertir en factura:** pasa la cotización a factura. La factura aparece también en **Facturas** para anotar abonos y cobrar por WhatsApp. Antes de abrirla y otra vez al guardar, la página revisa que nadie la haya convertido ya desde el otro teléfono (así no salen dos facturas de la misma cotización).
- En **Facturas → + Crear factura** puedes hacer una factura directa sin cotización. **Subir factura** es para guardar la foto o el PDF de una factura que ya tienes (hecha en papel o en otro programa).
- En una factura hecha con el diseño de Surteme, el cliente, el número, la fecha y los montos se cambian solo en **Editar productos y precios** (en **Facturas** se ven en gris; también mientras tus datos terminan de cargar). Así la factura que tiene el cliente y la de cobro siempre dicen lo mismo. Si le pones a una factura un número que ya tiene otra, no se cambia nada y la página te avisa.
- Si una cotización es muy larga (unos 35 productos o más), la imagen sale un poco menos nítida para que el teléfono pueda prepararla. Si aun así no se puede, sale un aviso rojo: divídela en dos.

## Para Claude (al publicar cambios)
- Cambiar `APP_VERSION` en `index.html` y el contenido de `version.txt` al mismo valor nuevo, para que los teléfonos se actualicen solos.
- Publicar en `main` y también en `gh-pages` (el sitio se publica desde `gh-pages`).

## Ventas del día
- La primera vez, en **Ventas** te pedirá pegar un texto en **SQL Editor** (botón **Copiar texto**).
- **Ventas de hoy** empieza en RD$0 cada día, solo. Suma las ventas que registras y las facturas con fecha de hoy.
- **Historial por día:** cada día queda guardado con su total, cantidad de ventas y ganancia. Toca un día para ver el detalle.
- Si la app se queda abierta cuando empieza un mes nuevo, el **Historial** y **Gastos** pasan solos al mes nuevo (si habías elegido otro mes o **Todo el tiempo**, se queda como lo elegiste).
- Aunque haya miles de ventas, pagos o precios, se cargan todos (la página los pide de 1,000 en 1,000).

## Inventario
- En la pestaña **Inventario** anotas lo que tienes en el almacén: **+ Nuevo producto** o **+ De Suplidores** (trae el nombre y el costo de tu lista de precios).
- **Empaques:** elige cómo lo compras (**fardo, caja, paquete o unidad**), cuántos paquetes trae el fardo o la caja y cuántas unidades trae cada paquete. La página te muestra la equivalencia, por ejemplo "1 caja = 10 paquetes = 1,000 unidades".
- **Precios:** pon lo que te cuesta la caja y el **% que le quieres ganar**, y los precios de caja, paquete y unidad salen solos. También puedes escribir el precio de la caja y los demás se calculan. Si escribes un precio de paquete o de unidad, se usa el tuyo. Abajo ves cuánto ganas en cada empaque.
- **Existencia:** se puede escribir combinando, por ejemplo 3 cajas y 4 paquetes. Se muestra igual: "Quedan 3 cajas, 4 paquetes".
- Pon "Avisarme si quedan menos de…" y el producto sale como **Por agotarse**.
- **Ventas:** en "Registrar una venta" elige el producto en **Del inventario**, si es por caja, paquete o unidad, y la cantidad. El monto, lo vendido y lo que costó se llenan solos, y el inventario baja.
- **Facturas:** al crear una factura usa **+ Del inventario** y toca el empaque (Caja, Paquete o Unidad). Al guardarla se descuenta. Las **cotizaciones no descuentan** hasta que las conviertes en factura.
- Si **borras** una venta o una factura, lo que descontó **regresa** al inventario.
- Dentro de un producto: **+ Entró mercancía** suma algo suelto y **Contar y corregir** ajusta cuando cuentas y no coincide.

## Compras de mercancía
- En **Inventario → Compras** pulsa **+ Registrar compra** cada vez que llega mercancía de un suplidor.
- Elige el suplidor, agrega los productos (**+ Del inventario** o **+ Producto nuevo**), la cantidad, si viene en cajas, paquetes o unidades, y el costo. El total se suma solo.
- Al guardar, **el inventario sube solo** y el costo de esos productos se actualiza (puedes quitar esa casilla).
- Marca **Ya la pagué** o déjala como **Debo**: arriba ves cuánto le debes a los suplidores.
- Puedes guardar la foto de la factura del suplidor.
- Las compras **no van en Gastos**: su costo ya se descuenta de tu ganancia cuando vendes.

## Calculadora: sumarle un %
- En **Calcular → Sumarle un %**: escribe lo que te cuesta y el % que le quieres ganar. Ejemplo: RD$10 + 15% = **RD$11.50** (ganas RD$1.50).
