///////////////////////////////////////////////////////////////////////////////
//
// Общие методы чтения файлов описаний
//
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
///////////////////////////////////////////////////////////////////////////////

// Формирует привычное имя типа из XML описания
//
// Параметры:
//   ТипИзXML - Строка- Имя типа XML
//
//  Возвращаемое значение:
//   Строка - Дружелюбное имя
//
Функция ПреобразоватьТип(ТипИзXML) Экспорт

	СоответствиеТипов = Новый Соответствие;

	СоответствиеТипов.Вставить("xs:boolean", "Булево");
	СоответствиеТипов.Вставить("xs:decimal", "Число");
	СоответствиеТипов.Вставить("xs:string", "Строка");
	СоответствиеТипов.Вставить("xs:dateTime", "Дата");
	СоответствиеТипов.Вставить("v8:ValueStorage", "Хранилище Значений");
	СоответствиеТипов.Вставить("v8:UUID", "UUID");
	СоответствиеТипов.Вставить("v8:Null", "Null");

	Если СтрНачинаетсяС(ТипИзXML, "xs") Или СтрНачинаетсяС(ТипИзXML, "v8") Тогда
	
		ПреобразованныйТип = СоответствиеТипов[ТипИзXML];
	
	ИначеЕсли СтрНачинаетсяС(ТипИзXML, "cfg:") Тогда

		ТипИзXML = СтрЗаменить(ТипИзXML, "cfg:", "");
		ЧастиТипа = СтрРазделить(ТипИзXML, ".");
		ТипОбъекта = СтрЗаменить(ЧастиТипа[0], "Ref", "");

		ПреобразованныйТип = ТипыОбъектовКонфигурации.ПолучитьИмяТипаНаРусском(ТипОбъекта) + "." + ЧастиТипа[1];

	Иначе

		ПреобразованныйТип = ТипИзXML;

	КонецЕсли;

	Возврат ПреобразованныйТип;

КонецФункции

// Возвращает полное наименование объекта конфигурации или модуля
//
// Параметры:
//   СтрокаОбъект - СтрокаТаблицыЗначений - Описание объекта или модуля конфигурации
//   ДобавлятьПрефиксДляОбщихМодулей - Булево - Признак, добавлять ли тип объекта для общих модулей
//
//  Возвращаемое значение:
//   Строка - Полное имя
//
Функция ПолноеИмяОбъекта(СтрокаМодуль, ДобавлятьПрефиксДляОбщихМодулей = Истина) Экспорт
	
	Если Утилиты.ПеременнаяСодержитСвойство(СтрокаМодуль, "ТипМодуля") Тогда // Передано описание модуля
		
		Если СтрокаМодуль.ТипМодуля <> ТипМодуля.ОбщийМодуль ИЛИ ДобавлятьПрефиксДляОбщихМодулей Тогда

			Возврат ТипыОбъектовКонфигурации.ПолучитьИмяТипаНаРусском(СтрокаМодуль.Родитель.Тип) + "." + СтрокаМодуль.Родитель.Наименование;

		Иначе
		
			Возврат СтрокаМодуль.Родитель.Наименование;
			
		КонецЕсли;
		
	Иначе
		
		Возврат ТипыОбъектовКонфигурации.ПолучитьИмяТипаНаРусском(СтрокаМодуль.Тип) + "." + СтрокаМодуль.Наименование;
		
	КонецЕсли;

КонецФункции

Функция ОбработатьСырыеДанные(СырыеДанные, ПараметрыЧтения) Экспорт
	
	ДанныеОбъекта = СтруктурыОписаний.СоздатьСтруктураОбъекта(ПараметрыЧтения.Тип);

	Для Каждого ЭлементПараметр Из ПараметрыЧтения.Свойства Цикл
		
		Параметр = ЭлементПараметр.Значение;
		Значение = Неопределено;
		
		Если НЕ СырыеДанные.Свойство(Параметр.Поле, Значение) Тогда
			
			Значение = "";
			
		КонецЕсли;
		
		ДанныеОбъекта[ЭлементПараметр.Ключ] = Значение;

	КонецЦикла;

	Возврат ДанныеОбъекта;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
///////////////////////////////////////////////////////////////////////////////
