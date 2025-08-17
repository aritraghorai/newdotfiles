#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawn, exec } = require("child_process");

// Simple chalk-like color functions (no external dependencies)
const colors = {
  red: (text) => `\x1b[31m${text}\x1b[0m`,
  green: (text) => `\x1b[32m${text}\x1b[0m`,
  yellow: (text) => `\x1b[33m${text}\x1b[0m`,
  blue: (text) => `\x1b[34m${text}\x1b[0m`,
  purple: (text) => `\x1b[35m${text}\x1b[0m`,
  cyan: (text) => `\x1b[36m${text}\x1b[0m`,
  bold: (text) => `\x1b[1m${text}\x1b[0m`,
  rainbow: (text) => {
    const rainbowColors = [31, 32, 33, 34, 35, 36];
    return text
      .split("")
      .map(
        (char, i) =>
          `\x1b[${rainbowColors[i % rainbowColors.length]}m${char}\x1b[0m`,
      )
      .join("");
  },
};

class PomodoroTimer {
  constructor() {
    this.durations = {
      work: 45,
      break: 10,
      longbreak: 30,
    };

    this.emojis = {
      work: "🍅",
      break: "☕",
      longbreak: "🛋️",
    };

    this.sounds = {
      work: "work_complete",
      break: "break_complete",
      longbreak: "longbreak_complete",
    };
  }

  showBanner() {
    console.clear();
    console.log(
      colors.red(
        colors.bold(
          "╔══════════════════════════════════════════════════════════════╗",
        ),
      ),
    );
    console.log(
      colors.red(
        colors.bold(
          "║  🍅 ____                            _                        ║",
        ),
      ),
    );
    console.log(
      colors.red(
        colors.bold(
          "║    |  _ \\ ___  _ __ ___   ___   __| | ___  _ __ ___          ║",
        ),
      ),
    );
    console.log(
      colors.red(
        colors.bold(
          "║    | |_) / _ \\| '_ ` _ \\ / _ \\ / _` |/ _ \\| '__/ _ \\         ║",
        ),
      ),
    );
    console.log(
      colors.red(
        colors.bold(
          "║    |  __/ (_) | | | | | | (_) | (_| | (_) | | | (_) |        ║",
        ),
      ),
    );
    console.log(
      colors.red(
        colors.bold(
          "║    |_|   \\___/|_| |_| |_|\\___/ \\__,_|\\___/|_|  \\___/         ║",
        ),
      ),
    );
    console.log(
      colors.red(
        colors.bold(
          "║                                                              ║",
        ),
      ),
    );
    console.log(
      colors.red(
        colors.bold(
          "║               ⏰ Focus • Rest • Repeat ⏰                    ║",
        ),
      ),
    );
    console.log(
      colors.red(
        colors.bold(
          "╚══════════════════════════════════════════════════════════════╝",
        ),
      ),
    );
    console.log();
  }

  getSessionColor(sessionType) {
    switch (sessionType) {
      case "work":
        return colors.red;
      case "break":
        return colors.green;
      case "longbreak":
        return colors.blue;
      default:
        return colors.yellow;
    }
  }

  // Generate different sound frequencies for different session types
  playSystemBeep(sessionType) {
    const patterns = {
      work: [800, 600, 400], // Descending tones for work completion
      break: [400, 600, 800], // Ascending tones for break completion
      longbreak: [500, 700, 500, 700, 500], // Alternating tones for long break
    };

    const pattern = patterns[sessionType] || [800, 600, 400];

    if (process.platform === "win32") {
      // Windows beep
      pattern.forEach((freq, index) => {
        setTimeout(() => {
          exec(`powershell -c "[console]::beep(${freq},500)"`);
        }, index * 600);
      });
    } else {
      // macOS/Linux - multiple beeps
      pattern.forEach((_, index) => {
        setTimeout(() => {
          process.stdout.write("\x07"); // ASCII bell character
        }, index * 300);
      });
    }
  }

  async playSound(sessionType) {
    console.log(colors.yellow("🔊 Playing completion sound..."));

    const message = `${sessionType.charAt(0).toUpperCase() + sessionType.slice(1)} session complete!`;

    // Try text-to-speech first
    await this.playTextToSpeech(message);

    // Then play system beeps
    this.playSystemBeep(sessionType);

    // Try playing system sounds
    this.playSystemSound(sessionType);
  }

  async playTextToSpeech(message) {
    return new Promise((resolve) => {
      let ttsCommand;
      let ttsArgs;

      if (process.platform === "darwin") {
        // macOS
        ttsCommand = "say";
        ttsArgs = [message];
      } else if (process.platform === "linux") {
        // Linux - try espeak or spd-say
        ttsCommand = "espeak";
        ttsArgs = [message];

        // Fallback to spd-say if espeak not available
        exec("which espeak", (error) => {
          if (error) {
            ttsCommand = "spd-say";
            ttsArgs = [message];
          }
        });
      } else if (process.platform === "win32") {
        // Windows PowerShell TTS
        const script = `Add-Type -AssemblyName System.Speech; $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer; $synth.Speak('${message}')`;
        ttsCommand = "powershell";
        ttsArgs = ["-Command", script];
      }

      if (ttsCommand) {
        const ttsProcess = spawn(ttsCommand, ttsArgs, { stdio: "ignore" });
        ttsProcess.on("close", () => resolve());
        ttsProcess.on("error", () => resolve()); // Continue even if TTS fails

        // Timeout after 5 seconds
        setTimeout(() => {
          ttsProcess.kill();
          resolve();
        }, 5000);
      } else {
        resolve();
      }
    });
  }

  playSystemSound(sessionType) {
    // Play different system sounds based on platform
    if (process.platform === "darwin") {
      // macOS system sounds
      const sounds = {
        work: "Glass",
        break: "Ping",
        longbreak: "Sosumi",
      };
      exec(`afplay /System/Library/Sounds/${sounds[sessionType]}.aiff`);
    } else if (process.platform === "linux") {
      // Linux - try paplay with system sounds
      exec("paplay /usr/share/sounds/alsa/Front_Left.wav", () => {
        // Fallback to simple beep if no sound file
        exec("speaker-test -t sine -f 1000 -l 1 -s 1");
      });
    } else if (process.platform === "win32") {
      // Windows system sounds
      const sounds = {
        work: "SystemAsterisk",
        break: "SystemExclamation",
        longbreak: "SystemNotification",
      };
      exec(
        `powershell -c "(New-Object Media.SoundPlayer 'C:\\Windows\\Media\\${sounds[sessionType]}.wav').PlaySync()"`,
      );
    }
  }

  async startSession(sessionType) {
    if (!this.durations[sessionType]) {
      console.log(colors.red(colors.bold("❌ Invalid session type!")));
      this.showHelp();
      return;
    }

    const duration = this.durations[sessionType];
    const emoji = this.emojis[sessionType];
    const colorFn = this.getSessionColor(sessionType);

    this.showBanner();

    // Session start notification
    console.log(
      colorFn(
        colors.bold(
          "╔════════════════════════════════════════════════════════════════╗",
        ),
      ),
    );
    console.log(
      colorFn(
        colors.bold(
          "║                                                                ║",
        ),
      ),
    );
    console.log(
      colorFn(
        colors.bold(
          `║  ${emoji}  Starting ${sessionType.toUpperCase()} session for ${duration} minutes! ${emoji}             ║`,
        ),
      ),
    );
    console.log(
      colorFn(
        colors.bold(
          "║                                                                ║",
        ),
      ),
    );
    console.log(
      colorFn(
        colors.bold(
          `║  ${new Date().toLocaleString()}                               ║`,
        ),
      ),
    );
    console.log(
      colorFn(
        colors.bold(
          "║                                                                ║",
        ),
      ),
    );
    console.log(
      colorFn(
        colors.bold(
          "╚════════════════════════════════════════════════════════════════╝",
        ),
      ),
    );
    console.log();

    // Session display
    console.log(colors.yellow(colors.bold("⏳ Session in progress...")));
    console.log();
    console.log(
      colors.rainbow(
        `${emoji} ${sessionType.toUpperCase()} SESSION - ${duration} MINUTES ${emoji}`,
      ),
    );
    console.log();
    console.log(colors.purple(colors.bold("◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇◆◇")));
    console.log();

    // Start timer with visual countdown
    await this.runTimer(duration, sessionType);

    // Session complete
    await this.showCompletion(sessionType, duration);
  }

  async runTimer(minutes, sessionType) {
    const totalSeconds = minutes * 60;
    let currentSecond = 0;

    return new Promise((resolve) => {
      const timer = setInterval(() => {
        currentSecond++;
        const remaining = totalSeconds - currentSecond;
        const remainingMinutes = Math.floor(remaining / 60);
        const remainingSeconds = remaining % 60;

        // Update progress line
        const percentage = Math.floor((currentSecond / totalSeconds) * 100);
        const barLength = 50;
        const filledLength = Math.floor(
          (currentSecond / totalSeconds) * barLength,
        );
        const bar =
          "█".repeat(filledLength) + "░".repeat(barLength - filledLength);

        process.stdout.write(
          `\r${colors.cyan(`Progress: [${bar}] ${percentage}% | ${remainingMinutes}:${remainingSeconds.toString().padStart(2, "0")} remaining`)}`,
        );

        if (currentSecond >= totalSeconds) {
          clearInterval(timer);
          console.log(); // New line after progress bar
          resolve();
        }
      }, 1000);
    });
  }

  async showCompletion(sessionType, duration) {
    console.clear();
    console.log(
      colors.green(
        colors.bold(
          "╔════════════════════════════════════════════════════════════════╗",
        ),
      ),
    );
    console.log(
      colors.green(
        colors.bold(
          "║                                                                ║",
        ),
      ),
    );
    console.log(
      colors.green(
        colors.bold(
          `║  ✅  ${sessionType.toUpperCase()} SESSION COMPLETE! ✅                      ║`,
        ),
      ),
    );
    console.log(
      colors.green(
        colors.bold(
          "║                                                                ║",
        ),
      ),
    );
    console.log(
      colors.green(
        colors.bold(
          `║  Duration: ${duration} minutes                                      ║`,
        ),
      ),
    );
    console.log(
      colors.green(
        colors.bold(
          `║  Completed at: ${new Date().toLocaleTimeString()}                        ║`,
        ),
      ),
    );
    console.log(
      colors.green(
        colors.bold(
          "║                                                                ║",
        ),
      ),
    );

    if (sessionType === "work") {
      console.log(
        colors.green(
          colors.bold(
            "║  🎉 Great job! Time for a well-deserved break! ☕             ║",
          ),
        ),
      );
    } else {
      console.log(
        colors.green(
          colors.bold(
            "║  🚀 Break's over! Ready to be productive again? 🍅           ║",
          ),
        ),
      );
    }

    console.log(
      colors.green(
        colors.bold(
          "║                                                                ║",
        ),
      ),
    );
    console.log(
      colors.green(
        colors.bold(
          "╚════════════════════════════════════════════════════════════════╝",
        ),
      ),
    );
    console.log();

    // **PLAY SOUND** - This is the new feature!
    await this.playSound(sessionType);

    // Show system notification
    this.showNotification(sessionType);

    this.showNextOptions();
  }

  showNotification(sessionType) {
    const message = `${sessionType.charAt(0).toUpperCase() + sessionType.slice(1)} session complete!`;

    // Try different notification methods based on OS
    if (process.platform === "darwin") {
      // macOS
      spawn("osascript", [
        "-e",
        `display notification "${message}" with title "🍅 Pomodoro Timer" sound name "Glass"`,
      ]);
    } else if (process.platform === "linux") {
      // Linux
      spawn("notify-send", ["🍅 Pomodoro Timer", message]);
    } else if (process.platform === "win32") {
      // Windows (PowerShell)
      spawn("powershell", [
        "-Command",
        `Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('${message}', '🍅 Pomodoro Timer')`,
      ]);
    }
  }

  showNextOptions() {
    console.log(colors.cyan(colors.bold("What's next?")));
    console.log(
      colors.yellow("  node pomo.js work     ") +
        "- Start work session (" +
        this.durations.work +
        " min)",
    );
    console.log(
      colors.yellow("  node pomo.js break    ") +
        "- Start break session (" +
        this.durations.break +
        " min)",
    );
    console.log(
      colors.yellow("  node pomo.js longbreak") +
        "- Start long break session (" +
        this.durations.longbreak +
        " min)",
    );
    console.log();
  }

  showStats() {
    console.log(
      colors.purple(colors.bold("╔════════════════════════════════════════╗")),
    );
    console.log(
      colors.purple(colors.bold("║           📊 POMODORO STATS 📊         ║")),
    );
    console.log(
      colors.purple(colors.bold("╠════════════════════════════════════════╣")),
    );
    console.log(
      colors.purple(
        colors.bold(
          `║ Work sessions:    ${this.durations.work} minutes      ║`,
        ),
      ),
    );
    console.log(
      colors.purple(
        colors.bold(
          `║ Break sessions:   ${this.durations.break} minutes       ║`,
        ),
      ),
    );
    console.log(
      colors.purple(
        colors.bold(
          `║ Long breaks:      ${this.durations.longbreak} minutes      ║`,
        ),
      ),
    );
    console.log(
      colors.purple(colors.bold("╚════════════════════════════════════════╝")),
    );
  }

  showHelp() {
    console.log(colors.yellow(colors.bold("\n🍅 Pomodoro Timer Commands:")));
    console.log(
      colors.red("  node pomo.js work     ") + "- Start work session (45 min)",
    );
    console.log(
      colors.green("  node pomo.js break    ") +
        "- Start break session (10 min)",
    );
    console.log(
      colors.blue("  node pomo.js longbreak") +
        "- Start long break session (30 min)",
    );
    console.log(
      colors.purple("  node pomo.js stats    ") + "- Show configuration",
    );
    console.log(colors.cyan("  node pomo.js help     ") + "- Show this help");
    console.log();
    console.log(colors.yellow("🔊 Sound Features:"));
    console.log("  • Text-to-speech announcements");
    console.log("  • System beeps with different patterns");
    console.log("  • Platform-specific system sounds");
    console.log();
  }
}

// Main execution
const timer = new PomodoroTimer();
const command = process.argv[2];

switch (command) {
  case "work":
    timer.startSession("work");
    break;
  case "break":
    timer.startSession("break");
    break;
  case "longbreak":
    timer.startSession("longbreak");
    break;
  case "stats":
    timer.showStats();
    break;
  case "help":
    timer.showHelp();
    break;
  default:
    timer.showHelp();
}
