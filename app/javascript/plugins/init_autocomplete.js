import places from 'places.js';

const initAutocomplete = () => {
  const addressInputs = document.querySelectorAll('#event_address');
  addressInputs.forEach((addressInput) => {
    if (addressInput) {
      places({ container: addressInput });
    }
  })
};

export { initAutocomplete };
