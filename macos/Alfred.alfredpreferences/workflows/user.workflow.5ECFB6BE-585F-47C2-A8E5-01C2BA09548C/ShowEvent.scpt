JsOsaDAS1.001.00bplist00�Vscript_ // Copyright (c) 2020 Dean Jackson <deanishe@deanishe.net>
// MIT Licence applies http://opensource.org/licenses/MIT

// run <calendarName> <eventId> | show specified event in Calendar.app.
// Using the calendar ID would be preferable, but that apparently doesn't
// work on Catalina.
function run(argv) {
	const app = Application('Calendar'),
		calendarName = argv[0],
		eventId = argv[1],
		calendars = app.calendars()
		
	console.log(`[ShowEvent] searching for event ${eventId} in ${calendars.length} calendars ...`)

	for (let i = 0; i < calendars.length; i++) {
		let cal = calendars[i]
		if (cal.name() !== calendarName) continue

		let events = cal.events.whose({uid: eventId})
		if (events.length) {
			app.activate()
			app.show(events[0])
			return
		}
	}
}
                              jscr  ��ޭ