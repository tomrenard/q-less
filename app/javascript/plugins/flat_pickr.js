import flatpickr from "flatpickr"
const initFlatPickr = () => {
  flatpickr("#date_id", {
    altInput: true,
    altFormat: "F j, Y",
    dateFormat: "dd.mm.yyyy"
  })
}

export { initFlatPickr }
