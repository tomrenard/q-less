const initToggleFavorite = () => {
  const favLink = document.querySelector("#favorite_link")
  const selectHeart = document.querySelector("#heart")
  if (favLink) {
    selectHeart.addEventListener('click', (event) => {
      if (favLink.dataset.favorite == 'true') {
        favLink.click()
        selectHeart.innerHTML = '<i class="fas fa-heart fa-lg"></i>'
        favLink.dataset.favorite = 'false'
      } else {
        favLink.click()
        selectHeart.innerHTML = '<i class="fas fa-heart-broken fa-lg"></i>'
        favLink.dataset.favorite = 'true'
      }
    })
  }
}

export { initToggleFavorite };
