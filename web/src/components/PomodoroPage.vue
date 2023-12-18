<template lang="pug">
h1(style="text-align: center;") Pomodoro
div(style="text-align: center;")
  el-progress(type="circle" :percentage="counterPercentage" color="#008080")
    box-icon(type="solid" name="hourglass")
  br
  h2 {{ displayText }}
  br
  el-button.start-button.custom-button(@click="buttonAction") {{ buttonText }}
</template>

<script>
export default {
  name: "PomodoroPage",
  data() {
    return {
      isCounting: false,
      seconds: 6,
      isBreak: false,
      displayText:
        "Inicie a contagem quando estiver preparado para começar um ciclo pomodoro",
    };
  },
  computed: {
    buttonText() {
      return this.isCounting ? "Parar" : "Começar";
    },
    buttonAction() {
      return this.isCounting ? this.stopPomdoro : this.startPomodoro;
    },
    counterPercentage() {
      let total = this.isBreak ? 4 : 6;
      return (this.seconds * 100) / total;
    },
  },
  methods: {
    startPomodoro() {
      this.isCounting = true;
      this.displayText =
        "Pode se concentrar tranquilo, nós te avisaremos quando os 25 minutos acabarem";
      setInterval(this.decreaseOneSecond, 1000);
    },
    stopPomdoro() {
      this.isCounting = false;
      this.seconds = 6;
      this.displayText =
        "Inicie a contagem quando estiver preparado para começar um ciclo pomodoro";
    },
    decreaseOneSecond() {
      if (!this.isCounting) return;

      if (this.seconds == 0 && !this.isBreak) {
        this.isBreak = true;
        this.seconds = 4;
        this.playNotification();
        this.displayText =
          "Você já se concentrou, hora de relaxar e descansar um pouquinho, te avisaremos quando for para voltar";
      } else if (this.seconds == 0 && this.isBreak) {
        this.isBreak = false;
        this.seconds = 6;
        this.playNotification();
        this.displayText =
          "Pode se concentrar tranquilo, nós te avisaremos quando os 25 minutos acabarem";
      } else {
        this.seconds--;
      }
    },
    playNotification() {
      const notificationAudio = new Audio(
        require("../assets/audio/notification_sound.mp3")
      );
      notificationAudio.play();
    },
  },
};
</script>

<style scoped>
.start-button {
  font-size: 20px !important;
  width: 120px !important;
  padding: 20px !important;
}
</style>
