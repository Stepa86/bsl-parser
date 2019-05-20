///////////////////////////////////////////////////////////////////////////////
//
// Модуль для чтения описаний метаданных 1с из EDT выгрузки
//
///////////////////////////////////////////////////////////////////////////////

#Использовать reflector

///////////////////////////////////////////////////////////////////////////////

Перем Рефлектор;
Перем РегулярныеВыражения;

///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
///////////////////////////////////////////////////////////////////////////////

// Выполняет чтение описания объекта с учетом параметров
//
// Параметры:
//   ТекстОписания - Строка - Описание объекта
//   ПараметрыЧтения - Структура - Настройки обработки полей
//
//  Возвращаемое значение:
//   Структура - Данные описания
//
Функция ПолучитьСвойства(ТекстОписания, ПараметрыЧтения) Экспорт
	
	Значения = Новый СписокЗначений();

	НайденныеСовпадения = РегулярныеВыражения.СвойстваОписания.НайтиСовпадения(ТекстОписания);
	
	Для Каждого Совпадение Из НайденныеСовпадения Цикл
		
		Имя = Совпадение.Группы[1].Значение;
		Значение = Совпадение.Группы[2].Значение;
		
		Значения.Добавить(Имя, Значение);

	КонецЦикла;

	СвойстваОписания = ОбработатьСырыеДанные(Значения, ПараметрыЧтения);
	
	Возврат СвойстваОписания;
	
КонецФункции

// Выполняет чтение описания объекта с учетом параметров
//
// Параметры:
//   ИмяФайла - Строка - Путь к файлу описания
//   ПараметрыЧтения - Структура - Настройки обработки полей
//
//  Возвращаемое значение:
//   Структура - Данные описания
//
Функция ПрочитатьСвойстваИзФайла(ИмяФайла, ПараметрыЧтения) Экспорт
	
	ТекстОписания = Утилиты.ПрочитатьФайл(ИмяФайла);
	
	Возврат ПолучитьСвойства(ТекстОписания, ПараметрыЧтения);

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС
///////////////////////////////////////////////////////////////////////////////

#Область МетодыЧтения
// Читает строку на разных языках
//
// Параметры:
//   Значение - Строка - Данные содержащие строку на разных языках
//
//  Возвращаемое значение:
//   Строка - Данные строки
//
Функция МногоязычнаяСтрока(Знач Значение) Экспорт
	
	Регулярка = РегулярныеВыражения.МногоязычнаяСтрока;
	Совпадения = Регулярка.НайтиСовпадения(Значение);
	
	Если Совпадения.Количество() Тогда
		
		Значение = Совпадения[0].Группы[1].Значение;
		
	Иначе
		
		Значение = "";
		
	КонецЕсли;
	
	Возврат Значение;

КонецФункции

// Читает описание типа
//
// Параметры:
//   Значение - Строка - Данные содержащие описание типа
//
//  Возвращаемое значение:
//   Строка - Значение типа
//
Функция ПолучитьТип(Знач Значение) Экспорт
	
	Регулярка = РегулярныеВыражения.ПолучитьТип;
	Совпадения = Регулярка.НайтиСовпадения(Значение);
	
	Если Совпадения.Количество() Тогда
		
		Значение = Совпадения[0].Группы[1].Значение;
		
	Иначе
		
		Значение = "";
		
	КонецЕсли;
	
	Возврат ЧтениеОписанийБазовый.ПреобразоватьТип(Значение);

КонецФункции

Функция ЗначениеБулево(Знач Значение) Экспорт
	
	Возврат СтрСравнить(Значение, "true") = 0;
	
КонецФункции

// Читает состав подсистемы
//
// Параметры:
//   Значение - Строка - Данные содержащие элемент состава
//
//  Возвращаемое значение:
//   Массив - Состав подсистемы
//
Функция СоставПодсистемы(Знач Значение) Экспорт

	Возврат Значение;
	
КонецФункции

#КонецОбласти

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
///////////////////////////////////////////////////////////////////////////////

Функция ОбработатьСырыеДанные(СырыеДанные, ПараметрыЧтения)
	
	СтруктураСырыхДанных = Новый Структура();
	
	Коллекции = Новый Структура();

	Для Каждого Свойство Из ПараметрыЧтения.Свойства Цикл
		
		Если Свойство.Значение.ЭтоКоллекция Тогда
			
			Коллекции.Вставить(Свойство.Значение.Поле);

		КонецЕсли;
		
	КонецЦикла;

	Для Каждого Элемент Из СырыеДанные Цикл
		
		Если Коллекции.Свойство(Элемент.Значение) Тогда
			
			Если НЕ СтруктураСырыхДанных.Свойство(Элемент.Значение) Тогда
				
				СтруктураСырыхДанных.Вставить(Элемент.Значение, Новый Массив());
				
			КонецЕсли;
			
			СтруктураСырыхДанных[Элемент.Значение].Добавить(Элемент.Представление);
			
		Иначе
			
			СтруктураСырыхДанных.Вставить(Элемент.Значение, Элемент.Представление);
			
		КонецЕсли;

	КонецЦикла;

	ДанныеОбъекта = ЧтениеОписанийБазовый.ОбработатьСырыеДанные(СтруктураСырыхДанных, ПараметрыЧтения);
	
	ЗначениеВМассиве = Новый Массив(1);
	ОписаниеСвойства = Неопределено;

	Для Каждого Элемент Из ДанныеОбъекта Цикл
		
		Если НЕ ПараметрыЧтения.Свойства.Свойство(Элемент.Ключ, ОписаниеСвойства) ИЛИ НЕ ЗначениеЗаполнено(ОписаниеСвойства.МетодПреобразования) Тогда
			Продолжить;
		КонецЕсли;

		Значение = Элемент.Значение;
			
		Если ПараметрыЧтения.Свойства[Элемент.Ключ].ЭтоКоллекция Тогда
			
			Для Инд = 0 По Значение.ВГраница() Цикл
				
				ЗначениеВМассиве[0] = Значение[Инд];
				Значение[Инд] = Рефлектор.ВызватьМетод(ЭтотОбъект, ОписаниеСвойства.МетодПреобразования, ЗначениеВМассиве);
				
			КонецЦикла;

		Иначе
			
			ЗначениеВМассиве[0] = Значение;
			Значение = Рефлектор.ВызватьМетод(ЭтотОбъект, ОписаниеСвойства.МетодПреобразования, ЗначениеВМассиве);

		КонецЕсли;
		
		ДанныеОбъекта[Элемент.Ключ] = Значение;
		
	КонецЦикла;
	
	Если ПараметрыЧтения.ЕстьПодчиненные Тогда
		
		Для Каждого Элемент Из СырыеДанные Цикл
			
			Если Элемент.Значение <> "languages" И ТипыОбъектовКонфигурации.ОписаниеТипаПоИмени(Элемент.Значение) <> Неопределено Тогда
				
				Если СтрНайти(Элемент.Представление, ".") = 0 Тогда
					
					ДанныеОбъекта.Подчиненные.Добавить(Элемент.Значение + "." + Элемент.Представление);
					
				Иначе

					ДанныеОбъекта.Подчиненные.Добавить(Элемент.Представление);
					
				КонецЕсли;
				
			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

	Возврат ДанныеОбъекта;
	
КонецФункции

Рефлектор = Новый Рефлектор;


РегулярныеВыражения = Новый Структура();
РегулярныеВыражения.Вставить("СвойстваОписания", Новый РегулярноеВыражение("<([a-zA-Z]+)\b[^>]*>([\s\S]*?)<\/\1>"));
РегулярныеВыражения.Вставить("МногоязычнаяСтрока", Новый РегулярноеВыражение("<value>([\s\S]*)<\/value>"));
РегулярныеВыражения.Вставить("ПолучитьТип", Новый РегулярноеВыражение("<types>([\s\S]*)<\/types>"));