## Lab S37 – Definir SLIs y SLOs para el Proyecto

> **Duración:** 60 minutos · **Objetivo:** Identificar métricas clave y calcular presupuesto de errores

### Ejercicio 1: Identificar SLIs apropiados para "devops-app"

**Contexto:** Nuestra aplicación "devops-app" en staging es un servicio que procesa requests HTTP. Vamos a identificar qué métricas importan realmente a los usuarios.

#### Paso 1.1: Entender qué es un buen SLI

Un buen SLI responde: **"¿Qué percibe el usuario cuando algo va mal?"**

```
❌ Malo: "CPU está al 85%" → El usuario no ve la CPU
❌ Malo: "Hay 1000 requests en cola" → El usuario solo ve latencia alta
✅ Bueno: "Las requests tardan más de 1 segundo" → El usuario lo siente
✅ Bueno: "50% de requests fallan con 500" → El usuario no puede usar la app
```

#### Paso 1.2: Tabla de SLIs para devops-app (Análisis sin herramientas)

**Tu tarea:** Completa la tabla analizando qué es importante monitorear. Piensa como SRE: "¿Qué vería y sentiría el usuario si esto falla?"


| Funcionalidad      | SLI Candidato                                          | ¿Es medible?              | Cómo lo mide el usuario                             |
| ------------------ | ------------------------------------------------------ | -------------------------- | ---------------------------------------------------- |
| **Disponibilidad** | % de requests que retornan status 2xx (no error 5xx)   | ✅ Sí (en logs/métricas) | Si hace click y la API responde o devuelve error     |
| **Velocidad**      | Latencia p95 (95% de requests < 200ms)                 | ✅ Sí (en métricas)      | Si la app responde rápido o se congela esperando    |
| **Confiabilidad**  | % de operaciones que devuelven resultado correcto      | ✅ Sí (con tests)         | Si obtiene valores correctos o incorrectos           |
| **Continuidad**    | % de pods corriendo vs esperado (3 de 3, 2 de 3, etc.) | ✅ Sí (en Kubernetes)     | Si la app se cae completamente o funciona lentamente |

#### Paso 1.3: Criterios para validar buenos SLIs

**Pregúntate para cada SLI:**

1. **¿El usuario lo percibe directamente?**

   - ✅ "Latencia alta" → Usuario lo siente
   - ❌ "CPU al 85%" → Usuario no ve CPU
2. **¿Se puede medir objetivamente?**

   - ✅ "95% de requests < 200ms" → Número medible
   - ❌ "El sistema es rápido" → Subjetivo
3. **¿Refleja realmente la calidad del servicio?**

   - ✅ "Disponibilidad 99.9%" → Refleja si funciona
   - ❌ "Uptime del servidor" → No es lo mismo que disponibilidad del servicio
4. **¿Podemos mejorar directamente el SLI?**

   - ✅ "Reducir latencia p95" → Podemos optimizar código
   - ❌ "Latencia p99.99" → Demasiado extremo para enfocarse

**Aplica estos criterios a devops-app:**

✅ **SLI de Disponibilidad (Excelente)**

- Usuario lo siente: Cuando hay error 500 no puede usar la app
- Medible: Contamos requests 2xx vs total
- Refleja calidad: Si está en 99.9%, el servicio funciona
- Mejora directa: Código más robusto, manejo de errores

✅ **SLI de Latencia p95 (Excelente)**

- Usuario lo siente: Espera larga = frustración
- Medible: Histogramas de duración de request
- Refleja calidad: Si es < 200ms, es rápido
- Mejora directa: Optimizar queries, cache, algoritmos

⚠️ **SLI de Confiabilidad del Cálculo (Avanzado)**

- Usuario lo siente: Resultados incorrectos = no confía en app
- Medible: Tests después de cada operation
- Refleja calidad: Exactitud garantizada
- Mejora directa: Tests + validación + logging

✅ **SLI de Continuidad de Pods (Bueno)**

- Usuario lo siente: App cae = no puede acceder
- Medible: Kubernetes replica status
- Refleja calidad: Si hay < 50% pods, es un problema
- Mejora directa: Configurar resource limits, health checks

### Ejercicio 2: Calcular Error Budgets

**Concepto clave:** El Error Budget es cuánto downtime "permitimos" sin incumplir el SLO.

#### Paso 2.1: Fórmula y ejemplo

```
Error Budget (%) = 100% - SLO
Error Budget (minutos/mes) = Error Budget (%) × 43200 minutos/mes*

*43200 min/mes = 30 días × 24 horas × 60 minutos
```

#### Paso 2.2: Ejemplos reales

**Ejemplo 1: Startup pequeña con SLO 99.0%**

```
Error Budget = 100% - 99.0% = 1.0%
Minutos/mes = 1.0% × 43200 = 432 minutos
Horas/mes = 432 / 60 = 7.2 horas

INTERPRETACIÓN:
La aplicación puede estar DOWN un total de 7.2 horas en el mes
sin incumplir el SLO. Con este presupuesto, podemos:
- Hacer mantenimiento: 2 horas/mes
- Tolerar 3-4 pequeños incidentes
```

**Ejemplo 2: Plataforma importante con SLO 99.9%**

```
Error Budget = 100% - 99.9% = 0.1%
Minutos/mes = 0.1% × 43200 = 43.2 minutos
Horas/mes = 43.2 / 60 = 0.72 horas

INTERPRETACIÓN:
La aplicación puede fallar solo 43 minutos en el mes entero.
Con este presupuesto, podemos:
- Hacer mantenimiento: 30 minutos máximo/mes
- Tolerar 1-2 pequeños incidentes muy controlados
```

**Ejemplo 3: Sistema crítico con SLO 99.99%**

```
Error Budget = 100% - 99.99% = 0.01%
Minutos/mes = 0.01% × 43200 = 4.32 minutos
Horas/mes = 4.32 / 60 = 0.072 horas

INTERPRETACIÓN:
La aplicación puede fallar solo 4 minutos en el mes entero.
Con este presupuesto, podemos:
- Hacer mantenimiento: Debe hacerse sin downtime (blue-green, canary)
- Apenas toleramos 1 pequeño incidente de 1-2 minutos
- Cualquier deploy que cause downtime es inaceptable
```

#### Paso 2.3: Tabla para completar

Completa los valores faltantes. **Formula: Error Budget (%) = 100% - SLO**


| SLO    | Uptime = SLO | Error Budget % | Minutos/mes | Horas/mes | Qué significa                              |
| ------ | ------------ | -------------- | ----------- | --------- | ------------------------------------------- |
| 99.0%  | 99.0%        | 1.0%           | 432         | 7.2       | Startup, desarrollando rápido              |
| 99.5%  | 99.5%        | 0.5%           | 216         | 3.6       | Servicio interno, menos crítico            |
| 99.9%  | 99.9%        | 0.1%           | 43.2        | 0.72      | Plataforma pública, usuarios importantes   |
| 99.95% | 99.95%       | 0.05%          | 21.6        | 0.36      | Sistema financiero, muy crítico            |
| 99.99% | 99.99%       | 0.01%          | 4.32        | 0.072     | Sistema militar/médico, crítico para vida |

**Cálculos para verificar:**

```
99.5%: Error Budget = 0.5% = 0.005 × 43200 = 216 minutos = 3.6 horas
99.95%: Error Budget = 0.05% = 0.0005 × 43200 = 21.6 minutos = 0.36 horas

```

### Ejercicio 3: Usar Error Budget para decidir deploys

**Caso de uso real:** Son las 14:00 del viernes. El equipo quiere hacer un deploy. ¿Podemos hacerlo?

#### Paso 3.1: Reporte de confiabilidad

Supongamos que hoy es 25 de septiembre (mes de 30 días). Revisamos las métricas:

```
SLO objetivo: 99.9% (disponibilidad)
Error Budget total/mes: 43.2 minutos

Días transcurridos: 25 de 30 = 83%
Error Budget esperado gastado: 83% × 43.2 = 35.9 minutos
Error Budget disponible hasta fin de mes: 43.2 - 35.9 = 7.3 minutos
```

#### Paso 3.2: Decisión de deploy

```
Histórico de nuestros deploys:
- Duración promedio del rollout: 3 minutos
- Riesgo de incidente post-deploy: 2% (ocurre 1 cada 50 deploys)
- Si hay incidente, duración promedio: 15 minutos
- Incidente esperado por deploy: 2% × 15 min = 0.3 minutos

Cálculo:
- Error Budget disponible: 7.3 minutos
- Si deployamos y hay incidente: 3 + 0.3 = 3.3 minutos gastados
- Error Budget después: 7.3 - 3.3 = 4 minutos restantes

DECISIÓN: ✅ SÍ PODEMOS DEPLOYAR
Pero es la última oportunidad del mes. Si hay dos incidentes,
agotamos el presupuesto.
```
 