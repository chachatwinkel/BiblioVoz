// Detección de manos con la cámara del navegador (MediaPipe Tasks Vision).
// Usa el GestureRecognizer, que se apoya en MediaPipe Hands (21 puntos por mano)
// y reconoce «Thumb_Up» y «Thumb_Down». Todo se procesa en el navegador:
// no se envía ni se guarda ninguna imagen.
//
// Se carga desde web/index.html con:  <script src="manos.js"></script>
// Desde Dart se usa a través de window.biblioManos (ver lib/camara_manos.dart).
(function () {
  'use strict';

  const CDN = 'https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@0.10.14';
  const MODELO =
    'https://storage.googleapis.com/mediapipe-models/gesture_recognizer/' +
    'gesture_recognizer/float16/1/gesture_recognizer.task';

  // Frames seguidos con el mismo gesto antes de darlo por bueno (evita falsos positivos).
  const FRAMES_ESTABLES = 10;
  // Tiempo mínimo entre dos valoraciones.
  const ENFRIAMIENTO_MS = 2500;
  const CONFIANZA_MIN = 0.6;

  // Pares de puntos que se unen para dibujar el esqueleto de la mano.
  const CONEXIONES = [
    [0, 1], [1, 2], [2, 3], [3, 4],
    [0, 5], [5, 6], [6, 7], [7, 8],
    [5, 9], [9, 10], [10, 11], [11, 12],
    [9, 13], [13, 14], [14, 15], [15, 16],
    [13, 17], [17, 18], [18, 19], [19, 20],
    [0, 17],
  ];

  let reconocedor = null;
  let contenedor = null;
  let video = null;
  let lienzo = null;
  let ctx = null;
  let flujo = null;
  let raf = 0;
  let activo = false;
  let ultimoTiempoVideo = -1;
  let gestoActual = '';
  let racha = 0;
  let hastaCuando = 0;

  /** Crea (una sola vez) el contenedor con el vídeo y el lienzo de superposición. */
  function crearVista() {
    if (contenedor) return contenedor;
    contenedor = document.createElement('div');
    contenedor.style.cssText =
      'position:relative;width:100%;height:100%;background:#000;overflow:hidden;';

    video = document.createElement('video');
    video.setAttribute('playsinline', '');
    video.muted = true;
    // Espejo, como un selfie: así el usuario ve su mano donde espera verla.
    video.style.cssText =
      'position:absolute;inset:0;width:100%;height:100%;object-fit:fill;transform:scaleX(-1);';

    lienzo = document.createElement('canvas');
    lienzo.width = 640;
    lienzo.height = 480;
    lienzo.style.cssText =
      'position:absolute;inset:0;width:100%;height:100%;transform:scaleX(-1);';
    ctx = lienzo.getContext('2d');

    contenedor.appendChild(video);
    contenedor.appendChild(lienzo);
    return contenedor;
  }

  async function cargarModelo() {
    if (reconocedor) return;
    const vision = await import(CDN + '/vision_bundle.mjs');
    const recursos = await vision.FilesetResolver.forVisionTasks(CDN + '/wasm');
    const opciones = (delegado) => ({
      baseOptions: { modelAssetPath: MODELO, delegate: delegado },
      runningMode: 'VIDEO',
      numHands: 1,
    });
    try {
      reconocedor = await vision.GestureRecognizer.createFromOptions(
        recursos, opciones('GPU'));
    } catch (_) {
      reconocedor = await vision.GestureRecognizer.createFromOptions(
        recursos, opciones('CPU'));
    }
  }

  function dibujar(manos, nombre, progreso) {
    ctx.clearRect(0, 0, lienzo.width, lienzo.height);
    const w = lienzo.width;
    const h = lienzo.height;

    for (const puntos of manos) {
      ctx.lineWidth = 3;
      ctx.strokeStyle = '#7c9cff';
      ctx.beginPath();
      for (const [a, b] of CONEXIONES) {
        ctx.moveTo(puntos[a].x * w, puntos[a].y * h);
        ctx.lineTo(puntos[b].x * w, puntos[b].y * h);
      }
      ctx.stroke();
      ctx.fillStyle = '#ffffff';
      for (const p of puntos) {
        ctx.beginPath();
        ctx.arc(p.x * w, p.y * h, 4, 0, Math.PI * 2);
        ctx.fill();
      }
    }

    // El lienzo está volteado con CSS: se dibuja el texto al revés para que se lea bien.
    ctx.save();
    ctx.translate(w, 0);
    ctx.scale(-1, 1);
    ctx.font = 'bold 22px sans-serif';
    ctx.textBaseline = 'top';
    let texto = 'Muestra un pulgar arriba o abajo';
    if (nombre === 'Thumb_Up') texto = 'Pulgar arriba';
    if (nombre === 'Thumb_Down') texto = 'Pulgar abajo';
    ctx.fillStyle = 'rgba(0,0,0,0.55)';
    ctx.fillRect(8, 8, ctx.measureText(texto).width + 16, 34);
    ctx.fillStyle = '#ffffff';
    ctx.fillText(texto, 16, 12);
    if (progreso > 0) {
      ctx.fillStyle = 'rgba(0,0,0,0.55)';
      ctx.fillRect(8, h - 22, w - 16, 14);
      ctx.fillStyle = '#4caf50';
      ctx.fillRect(10, h - 20, (w - 20) * Math.min(progreso, 1), 10);
    }
    ctx.restore();
  }

  function bucle(alGesto) {
    if (!activo) return;
    raf = requestAnimationFrame(() => bucle(alGesto));
    if (!reconocedor || video.readyState < 2) return;
    if (video.currentTime === ultimoTiempoVideo) return;
    ultimoTiempoVideo = video.currentTime;

    const res = reconocedor.recognizeForVideo(video, performance.now());
    const manos = res.landmarks || [];
    const mejor = res.gestures && res.gestures[0] && res.gestures[0][0];
    const nombre =
      mejor && mejor.score >= CONFIANZA_MIN ? mejor.categoryName : '';
    const valido = nombre === 'Thumb_Up' || nombre === 'Thumb_Down';

    if (valido && nombre === gestoActual) {
      racha++;
    } else {
      gestoActual = valido ? nombre : '';
      racha = valido ? 1 : 0;
    }

    const ahora = Date.now();
    if (valido && racha >= FRAMES_ESTABLES && ahora >= hastaCuando) {
      hastaCuando = ahora + ENFRIAMIENTO_MS;
      racha = 0;
      alGesto(nombre === 'Thumb_Up' ? 'up' : 'down');
    }
    dibujar(manos, valido ? nombre : '', racha / FRAMES_ESTABLES);
  }

  /**
   * Pide la cámara, carga el modelo y empieza a detectar.
   * [alGesto] recibe 'up' o 'down'. Devuelve true si todo arrancó bien.
   */
  async function iniciar(alGesto) {
    if (activo) return true;
    try {
      crearVista();
      flujo = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: 'user', width: 640, height: 480 },
        audio: false,
      });
      video.srcObject = flujo;
      await video.play();
      await cargarModelo();
      activo = true;
      ultimoTiempoVideo = -1;
      gestoActual = '';
      racha = 0;
      bucle(alGesto);
      return true;
    } catch (e) {
      console.error('BiblioVoz manos:', e);
      detener();
      return false;
    }
  }

  /** Para la detección y libera la cámara (el piloto de la webcam se apaga). */
  function detener() {
    activo = false;
    if (raf) cancelAnimationFrame(raf);
    raf = 0;
    if (flujo) flujo.getTracks().forEach((t) => t.stop());
    flujo = null;
    if (video) video.srcObject = null;
    if (ctx) ctx.clearRect(0, 0, lienzo.width, lienzo.height);
  }

  window.biblioManos = { crearVista, iniciar, detener };
})();
