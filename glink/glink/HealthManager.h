//
//  HealthManager.h
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/12/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HealthDTO.h"
#import "HealthDayDTO.h"

extern const float kMinCH;
extern const float kMaxCH;
extern const float kWarnCH;

extern const float kMinGlucemia;
extern const float kMaxGlucemia;
extern const float kHipoGlucemia;
extern const float kHiperGlucemia;

extern const float kMinGlucemiaOK;
extern const float kMaxGlucemiaOK;

extern const float kMinRelacion;
extern const float kMaxRelacion;

extern const float kMinTarget;
extern const float kMaxTarget;

extern const float kMinSensibilidad;
extern const float kMaxSensibilidad;

extern const float kMinInsulina;
extern const float kMaxInsulina;

#define kHelpCarbohidratos @"Este valor debe ser completado con la cantidad de carbohidratos que usted va a ingerir en la comida próxima";
#define kHelpGlucemia @"Este campo debe ser completado con lo que haya detectado el dispositivo capilar o sensor previo a la comida próxima";
#define kHelpRelacion @"Este dato debe ser indicado por su medico, representa la cantidad de carbohidratos que una unidad de insulina utilizara para mantener la glucemia normal.";
#define kHelpTarget @" Este dato debe ser indicado por su médico, es el valor de glucemia a partir del cual el calculador sumará insulina según glucemia, a la insulina calculada según los carbohidratos que va a ingerir";
#define kHelpSensibilidad @"Este dato debe ser indicado por su médico, representa la cantidad de glucemia que va a disminuir por cada una unidad de insulina.";

#define kHelpGrafico @"En este gráfico de estadísticas podrá observar el promedio de todos sus registros según diversas categorías. Esto le sirve para poder analizar con claridad su progreso a través del tiempo. Las principales categorías son Glucemia, Carbohidratos e Insulina. \n\nPodrá cambiar las mismas mediante los segmentos de la sección superior. A su vez, para cada una de estas categorías, se realiza una división según momento del día, para que pueda apreciar qué comida tiene valores mayores y pueda usarlo como guía para saber hacia donde debe apuntar su tratamiento. \n\nPor cada uno de estos datos le informamos su promedio de la última semana, última quincena y del último mes partiendo del día actual. Con la idea de poder realizar una comparación, la última columna corresponde al promedio del mes anterior al actual.";

#define kHelpGeneral @"La app de GluComando le permite simplificar muchas de las acciones que debe realizar cotidianamente un usuario que requiere aplicarse dosis de insulina. Las opciones de uso principales se dividen en 4 grandes secciones, correspondientes cada una a una tab de la sección inferior: Cálculo de bolo, Cálculo de Carbohidratos, Estadísticas de Usuario e Información de mi médico. \n\nEn la sección de cálculo de bolo usted podrá obtener la dosis recomendada de insulina ingresando las variables correspondientes a través de 3 simples pasos que comienzan al seleccionar Iniciar Cálculo de Bolo. \n\nEn la sección de cálculo de carbohidratos usted podrá explorar un listado sumamente completo de opciones disponibles, y agregar porciones de comida usando el numerador a la derecha de cada ítem. Utilice los botones de Categorías y Búsqueda para ayudarse a encontrar el ítem que busca y presione Calcular cuando haya terminado de elegir todos los componentes de su próxima comida. \n\nEn la sección de estadísticas podra encontrar un listado que incluye un cuadro de progreso por cada día en que haya habido registros para poder analizar su progreso de una forma clara y comprensiva: cada curva determina las cantidades y horarios del día en que realizó sus consumos. \n\nEn la sección de médico personal usted puede guardar datos de su médico que le sean útiles para poder recuperarlos fácilmente en cualquier momento en que lo necesite.";

@interface HealthManager : NSObject

+ (instancetype) sharedInstance;
- (float) calculoFinalBolo;
- (void) storeNewItem: (HealthDTO*) dto;
- (NSMutableArray*) retrieveAllItems;
- (NSMutableArray*) retrieveAllDayItems;
- (CGFloat) timeSinceLastEntry;
- (BOOL) deleteObject: (HealthDTO*) targetDto;

@property float fakeGlucemia;
@property float glucemia;
@property float cantidadch;
@property float relacionch;
@property float target;
@property float sensibilidad;
@property float reductionFactor;

@end
