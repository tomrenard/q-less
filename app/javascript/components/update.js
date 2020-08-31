const initToggleFavorite = () => {
  const favLink = document.querySelector("#favorite_link")
  if (favLink) {
    favLink.addEventListener('click', (event) => {
      if (favLink.innerText === "favorite") { // innerhtml
        favLink.innerText = "Unfavorite"
      } else {
        favLink.innerText = "Favorite"
      }
    })
  }
}

export { initToggleFavorite }
