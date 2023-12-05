<template lang="pug">
div(style="text-align: center;")
  h1 Pomodoro
  el-progress(type="circle" :percentage="counterPercentage" color="#008080")
    box-icon(type="solid" name="hourglass")
  br
  h2 {{ displayText }}
  br
  button.start-button(@click="buttonAction") {{ buttonText }}
</template>

<script>
export default {
  name: "PomodoroPage",
  data() {
    return {
      isCounting: false,
      seconds: 9,
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
      let total = this.isBreak ? 4 : 9;
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
      this.seconds = 9;
    },
    decreaseOneSecond() {
      if (!this.isCounting) return;

      if (this.seconds == 0 && !this.isBreak) {
        this.isBreak = true;
        this.seconds = 4;
        alert("Ei! Olha aqui, é hora de descansar um pouco.");
        this.displayText =
          "Você já se concentrou, hora de relaxar e descansar um pouquinho, te avisaremos quando for para voltar";
      } else if (this.seconds == 0 && this.isBreak) {
        this.isBreak = false;
        this.seconds = 9;
        alert("Ei! Olha aqui, é hora de se concentrar!!");
        this.displayText =
          "Pode se concentrar tranquilo, nós te avisaremos quando os 25 minutos acabarem";
      } else {
        this.seconds--;
      }
    },
  },
};
</script>

<style scoped>
.start-button {
  background-color: #008080;
  color: #fff;
  font-size: 20px;
  font-weight: bold;
  padding: 10px;
  width: 120px;
  border-radius: 4px;
  border: none;
  cursor: pointer;
  outline: none;
  border-bottom: solid 8px #025a5a;
}

.start-button:active {
  transform: translateY(4px);
  border-bottom: solid 4px #025a5a;
}
</style>
