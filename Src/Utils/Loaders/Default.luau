return function()
	wax.shared.EspCache = {
		Players = {},
	}

	wax.shared.Load('Tabs', 'Visuals')()
	wax.shared.Load('Functions', 'Visuals')()
end
