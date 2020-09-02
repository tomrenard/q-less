const initToggleFavorite = () => {
  const favLink = document.querySelector("#favorite_link")
  console.log(favLink)
  if (favLink) {
    favLink.addEventListener('click', (event) => {
      if (favLink.innerHTML === '<i class="fas fa-heart"></i>') {
        favLink.innerHTML = '<i class="fas fa-heart-broken"></i>'
      } else {
        favLink.innerHTML = '<i class="fas fa-heart"></i>'
      }
    })
  }
}

export { initToggleFavorite }
