// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

document.addEventListener('DOMContentLoaded', function() {
	const citySearchInput   = document.getElementById('city-search');
	const stateSearchSelect = document.getElementById('state-select');
	const cityList = document.getElementById('city-list');

	citySearchInput.addEventListener('input', function() {
		const city  = this.value;
		const state = stateSearchSelect.value;

		fetch(`/cities/search?city=${city}&state=${state}`)
		.then(response => response.json())
		.then(data => {
			cityList.innerHTML = ''; // Clear the list

			data.forEach(city => {
				const trItem = document.createElement('tr')
				const tdItemState = document.createElement('td');
				const tdItemCity = document.createElement('td');

				tdItemCity.textContent = `${city.city}`;
				tdItemState.textContent = `${city.state.name}`;

				trItem.appendChild(tdItemCity)
				trItem.appendChild(tdItemState)
				cityList.appendChild(trItem);
			});
		});
	});

	stateSearchSelect.addEventListener('input', function() {
		const city  = citySearchInput.value;
		const state = this.value;

		fetch(`/cities/search?city=${city}&state=${state}`)
		.then(response => response.json())
		.then(data => {
			cityList.innerHTML = ''; // Clear the list

			data.forEach(city => {
				const trItem = document.createElement('tr')
				const tdItemState = document.createElement('td');
				const tdItemCity = document.createElement('td');

				tdItemCity.textContent = `${city.city}`;
				tdItemState.textContent = `${city.state.name}`;

				trItem.appendChild(tdItemCity)
				trItem.appendChild(tdItemState)
				cityList.appendChild(trItem);
			});
		});
	});
});
  