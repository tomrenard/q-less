const initToggleFavorite = () => {
  const favLinks = document.querySelectorAll("#favorite_link a")
  const selectHearts = document.querySelectorAll("#heart")
  if (favLinks[0]) {
    selectHearts.forEach((selectHeart, index) => {
      selectHeart.addEventListener('click', (event) => {
        if (favLinks[index].dataset.favorite == 'true') {
          favLinks[index].click()
          selectHeart.innerHTML = '<i class="fas fa-heart-broken fa-lg"></i>'
          favLinks[index].dataset.favorite = 'false'
        } else {
          favLinks[index].click()
          selectHeart.innerHTML = '<i class="fas fa-heart fa-lg"></i>'
          favLinks[index].dataset.favorite = 'true'
        }
      })
    })
  }
}

export { initToggleFavorite };
