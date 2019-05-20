///////////////////////////////////////////////////////////////////////////////
//
// Содержит описания структур для разбора конфигураций
//
///////////////////////////////////////////////////////////////////////////////

Перем СвойстваОбъектов;
Перем ПолученныеОписанияОбъектов;

///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
///////////////////////////////////////////////////////////////////////////////

#Область КоллекцииОбъектов

Функция ТаблицаОписанияОбъектовКонфигурации() Экспорт
	
	ОбъектыКонфигурации = Новый ТаблицаЗначений;
	ОбъектыКонфигурации.Колонки.Добавить("Наименование");
	ОбъектыКонфигурации.Колонки.Добавить("Тип");
	ОбъектыКонфигурации.Колонки.Добавить("ПолноеНаименование");
	ОбъектыКонфигурации.Колонки.Добавить("ПутьКФайлу");
	ОбъектыКонфигурации.Колонки.Добавить("ПутьККаталогу");
	ОбъектыКонфигурации.Колонки.Добавить("Подсистемы");
	ОбъектыКонфигурации.Колонки.Добавить("Описание");
	ОбъектыКонфигурации.Колонки.Добавить("Родитель");
	
	Возврат ОбъектыКонфигурации;
	
КонецФункции

Функция ТаблицаОписанияМодулей() Экспорт
	
	МодулиКонфигурации = Новый ТаблицаЗначений;
	МодулиКонфигурации.Колонки.Добавить("ТипМодуля");
	МодулиКонфигурации.Колонки.Добавить("Родитель");
	МодулиКонфигурации.Колонки.Добавить("ПутьКФайлу");	
	МодулиКонфигурации.Колонки.Добавить("НаборБлоков");
	МодулиКонфигурации.Колонки.Добавить("Содержимое");
	МодулиКонфигурации.Колонки.Добавить("РодительФорма");
	МодулиКонфигурации.Колонки.Добавить("РодительКоманда");	
	МодулиКонфигурации.Колонки.Добавить("ОписаниеМодуля");
	
	Возврат МодулиКонфигурации;
	
КонецФункции

Функция ТаблицаОписанияПодсистем() Экспорт
	
	ОписаниеПодсистем = Новый ТаблицаЗначений;
	ОписаниеПодсистем.Колонки.Добавить("ОбъектМетаданных");
	ОписаниеПодсистем.Колонки.Добавить("Имя");
	ОписаниеПодсистем.Колонки.Добавить("Представление");
	ОписаниеПодсистем.Колонки.Добавить("ПодсистемаОписание");
	ОписаниеПодсистем.Колонки.Добавить("Визуальная");
	ОписаниеПодсистем.Колонки.Добавить("Родитель");
	ОписаниеПодсистем.Колонки.Добавить("ПредставлениеКратко");
	ОписаниеПодсистем.Колонки.Добавить("ИмяКратко");
	
	Возврат ОписаниеПодсистем;
	
КонецФункции

#КонецОбласти

Функция ОписаниеОбъектаКонфигурацииЗначенияПоУмолчанию() Экспорт
	
	Возврат Новый Структура(
	"Наименование, Тип, ПолноеНаименование, ПутьКФайлу, ПутьККаталогу, Подсистемы, Описание, Родитель", 
	"", "", "", "", "", Новый Массив);
	
КонецФункции

Функция СоздатьСтруктураОбъекта(ТипОбъекта) Экспорт
	
	ОписаниеОбъекта = ОписаниеСвойствОбъекта(ТипОбъекта);
	
	Данные = Новый Структура();
	
	Для Каждого Описание Из ОписаниеОбъекта.Свойства Цикл
		
		Если ОписаниеОбъекта.ЕстьЗначенияПоУмолчанию Тогда
			
			Данные.Вставить(Описание.Наименование, Описание.ЗначениеПоУмолчанию);
			
		ИначеЕсли ЗначениеЗаполнено(Описание.ТипЗначения) Тогда
			
			Данные.Вставить(Описание.Наименование, Новый(Описание.ТипЗначения));
			
		Иначе

			Данные.Вставить(Описание.Наименование);

		КонецЕсли;
		
	КонецЦикла;
	
	Если ОписаниеОбъекта.ЕстьПодчиненные Тогда
		
		Данные.Вставить("Подчиненные", Новый Массив());
		
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

Функция СоздатьСокращеннуюСтруктураОбъекта(ТипОбъекта) Экспорт
	
	ОписаниеОбъекта = ОписаниеСвойствОбъекта(ТипОбъекта);
	
	Данные = Новый Структура("Наименование", "");
	
	Если ОписаниеОбъекта.ЕстьПодчиненные Тогда
		
		Данные.Вставить("Подчиненные", Новый Массив());
		
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

Функция ОписаниеСвойствОбъекта(ТипОбъекта) Экспорт
	
	Если ПолученныеОписанияОбъектов[ТипОбъекта] <> Неопределено Тогда
		
		Возврат ПолученныеОписанияОбъектов[ТипОбъекта];
		
	КонецЕсли;
	
	Свойства = СвойстваОбъектов[ТипыОбъектовКонфигурации.НормализоватьИмя(ТипОбъекта)];
	
	Если Свойства = Неопределено Тогда
		
		Свойства = БазовоеОписаниеСвойствОбъекта();
		ПараметрыПродукта.ПолучитьЛог().Предупреждение("Нет описания типа %1. Использовано описание по-умолчанию", ТипОбъекта);
		
	КонецЕсли;
	
	ОписаниеОбъекта = Новый Структура("Тип, Свойства, ЕстьПодчиненные, ЕстьЗначенияПоУмолчанию", ТипОбъекта);
	
	НормализованнаяТаблицаСвойств = Новый ТаблицаЗначений();
	НормализованнаяТаблицаСвойств.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	НормализованнаяТаблицаСвойств.Колонки.Добавить("ЭлементEDT", Новый ОписаниеТипов("Строка"));
	НормализованнаяТаблицаСвойств.Колонки.Добавить("ЭлементDesigner", Новый ОписаниеТипов("Строка"));
	НормализованнаяТаблицаСвойств.Колонки.Добавить("МетодПреобразования", Новый ОписаниеТипов("Строка"));
	НормализованнаяТаблицаСвойств.Колонки.Добавить("ЗначениеПоУмолчанию", Новый ОписаниеТипов("Строка"));
	НормализованнаяТаблицаСвойств.Колонки.Добавить("ТипЗначения", Новый ОписаниеТипов("Строка"));
	НормализованнаяТаблицаСвойств.Колонки.Добавить("ЭтоКоллекция", Новый ОписаниеТипов("Булево"));
	
	Для Каждого ОписаниеСвойства Из Свойства Цикл
		
		Свойство = НормализованнаяТаблицаСвойств.Добавить();
		ЗаполнитьЗначенияСвойств(Свойство, ОписаниеСвойства);
		Свойство.ЭтоКоллекция = Свойство.ТипЗначения = "Массив";
		
	КонецЦикла;

	ОписаниеОбъекта.Свойства = НормализованнаяТаблицаСвойств;
	ОписаниеОбъекта.ЕстьПодчиненные = ТипыОбъектовКонфигурации.ОписаниеТипаПоИмени(ТипОбъекта).ЕстьПодчиненные = "true";
	ОписаниеОбъекта.ЕстьЗначенияПоУмолчанию = Свойства.Колонки.Найти("ЗначениеПоУмолчанию") <> Неопределено;
	
	ПолученныеОписанияОбъектов.Вставить(ТипОбъекта, ОписаниеОбъекта);
	
	Возврат ОписаниеОбъекта;
	
КонецФункции

Функция БазовоеОписаниеСвойствОбъекта() Экспорт
	
	Возврат СвойстваОбъектов["Default"];
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
///////////////////////////////////////////////////////////////////////////////

Процедура ЗагрузитьСвойстваОбъектов()
	
	ФайлОписаний = ОбъединитьПути(Утилиты.КаталогМакеты(), "СвойстваОбъектов.md");
	
	Чтение = Новый ЧтениеТекста();
	Чтение.Открыть(ФайлОписаний, КодировкаТекста.UTF8);
	
	СвойстваОбъектов = Новый Соответствие();
	
	Пока Истина Цикл
		
		СтрокаЗаголовка = Утилиты.НайтиСледующийЗаголовокMarkdown(Чтение, "## Реквизиты");
		
		Если СтрокаЗаголовка = Неопределено Тогда
			
			Прервать;
			
		КонецЕсли;
		
		ИмяТипа = СокрЛП(Сред(СтрокаЗаголовка, 13));
		ИмяТипа = ТипыОбъектовКонфигурации.НормализоватьИмя(ИмяТипа);
		
		Свойства = Утилиты.ПрочитатьТаблицуMarkdown(Чтение);
		
		СвойстваОбъектов.Вставить(ИмяТипа, Свойства);
		
	КонецЦикла;
	
	Чтение.Закрыть();
	
КонецПроцедуры

ПолученныеОписанияОбъектов = Новый Соответствие();

ЗагрузитьСвойстваОбъектов();