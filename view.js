(function () {
  'use strict';

  if (window.__MONITORING_BYPASS_ACTIVE__) return;
  window.__MONITORING_BYPASS_ACTIVE__ = true;

  // 1. Bloqueia a propagação de TODOS os eventos relacionados a perda de foco/visibilidade
  const blockedEvents = ['blur', 'focusout', 'pagehide', 'visibilitychange'];
  
  blockedEvents.forEach((eventName) => {
    window.addEventListener(
      eventName,
      (e) => {
        e.stopImmediatePropagation();
        e.stopPropagation();
      },
      true // Fase de captura (executa antes de qualquer listener da aplicação)
    );
  });

  // 2. Congela a Page Visibility API no protótipo (impede redefinições pelo React)
  const proto = Document.prototype;
  
  try {
    Object.defineProperties(proto, {
      hidden: {
        get: () => false,
        configurable: false,
      },
      visibilityState: {
        get: () => 'visible',
        configurable: false,
      },
      hasFocus: {
        value: () => true,
        writable: false,
      },
    });
  } catch (e) {
    // Fallback caso o protótipo já esteja selado
    Object.defineProperty(document, 'hidden', { get: () => false });
    Object.defineProperty(document, 'visibilityState', { get: () => 'visible' });
  }

  // 3. Anula propriedades diretas de eventos
  window.onblur = null;
  window.onfocusout = null;
  document.onvisibilitychange = null;

  console.log('%c[Bypass API] Monitoramento neutralizado com sucesso.', 'color: #00ff00; font-weight: bold;');
})();