// 오늘의 주접 웹 데모: 기분을 고르면 위젯에 그 기분의 주접이 뜨고, 다음 주접은 전체에서 무작위로 나온다.
// 규칙은 앱과 같다: 기분 선택은 그 기분의 첫 주접 (WidgetManager.updateCurrentQuote),
// 다음 주접은 281개 전체에서 무작위 (WidgetManager.loadNextQuote). 문구는 앱의 Quotes.xcstrings 그대로.
(() => {
  const root = document.getElementById("demo");
  if (!root) return;
  const T = JSON.parse(root.dataset.text);
  let mood = 0, index = T.moods[0].first;

  root.innerHTML = `
    <div class="demo-stage">
      <div class="jj-widget"><p class="jj-quote" aria-live="polite"></p></div>
    </div>
    <div class="demo-controls">
      <div class="demo-chips" role="group">
        ${T.moods.map((m, i) => `<button type="button" class="chip" data-mood="${i}" aria-pressed="false">
          <span aria-hidden="true">${m.emoji}</span> ${m.name}</button>`).join("")}
      </div>
      <button type="button" class="jj-next">${T.next} →</button>
      <p class="muted small demo-note">${T.note}</p>
    </div>`;

  const quote = root.querySelector(".jj-quote"), widget = root.querySelector(".jj-widget");

  function render() {
    quote.textContent = T.quotes[index];
    root.querySelectorAll("[data-mood]").forEach(b => b.setAttribute("aria-pressed", String(+b.dataset.mood === mood)));
    widget.classList.remove("pop"); void widget.offsetWidth; widget.classList.add("pop");
  }

  root.addEventListener("click", e => {
    const chip = e.target.closest("[data-mood]");
    if (chip) {
      mood = +chip.dataset.mood;
      index = T.moods[mood].first;
      render();
    } else if (e.target.closest(".jj-next")) {
      let next;
      do next = Math.floor(Math.random() * T.quotes.length); while (next === index);
      index = next; mood = -1;
      render();
    }
  });

  render();
})();
