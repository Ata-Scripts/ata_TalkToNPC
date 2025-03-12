var app = new Vue({
  el: "#app",
  data: {
    display: false,
    chatCoolDown: false,
    name: "",
    totalPrice: 0,
    addedItems: [],
    items: [],
    inventoryItems: [],
    chatHistory: [],
    actionsList: [],
    isTyping: false,
    typingSpeed: 20,
    currentText: "",
    config: null,
    dialog: "",
    options: [],
    canClick: true,
  },
  mounted() {
    // Initialize sound settings
    if (this.typeSound) {
      this.typeSound.volume = 0.5; // Default volume
    }
    window.addEventListener("message", (event) => {
      if (event.data.action === "openUI") {
        this.display = true;
        this.name = event.data.name;
        this.dialog = event.data.dialog;
        this.options = event.data.options;
        this.SellItem = event.data.SellItem;
        this.BuyItem = event.data.BuyItem;
        this.config = event.data.config;
        this.actionsList = this.options.map((option) => ({
          text: option.text,
          event: option.event,
          serverSide: option.serverSide,
          args: option.args,
          followUp: option.followUp,
        }));
        this.chatHistory = [];
        this.chatHistory.push({
          type: "text",
          data: this.dialog,
          left: true,
        });
      } else if (event.data.action === "setFollowUpOptions") {
        this.handleFollowUp(event.data.options);
      }
    });
  },
  computed: {
    plusHandler: function () {
      return (i, index) => {
        if (app.chatHistory[i].data[index].count >= 0) {
          app.chatHistory[i].data[index].count++;
          const item = app.chatHistory[i].data[index];
          const existingItem = app.addedItems.find((x) => x.name === item.name);
          if (!existingItem) {
            app.addedItems.push({ ...item });
          } else {
            existingItem.count++;
          }
        }
      };
    },
    minusHandler: function () {
      return (i, index) => {
        if (app.chatHistory[i].data[index].count > 0) {
          app.chatHistory[i].data[index].count--;
          const item = app.chatHistory[i].data[index];
          const existingItemIndex = app.addedItems.findIndex(
            (x) => x.name === item.name
          );
          if (existingItemIndex !== -1) {
            if (app.chatHistory[i].data[index].count === 0) {
              app.addedItems.splice(existingItemIndex, 1);
            } else {
              app.addedItems[existingItemIndex].count--;
            }
          }
        }
      };
    },
    actionClick: function () {
      return (action) => {
        this.handleAction(action);
      };
    },
    buyCash: function () {
      return () => {
        if (app.addedItems.length > 0) {
          $.post(
            `https://${GetParentResourceName()}/buyitemsCash`,
            JSON.stringify({ items: app.addedItems })
          );
        }
      };
    },
    buyBank: function () {
      return () => {
        if (app.addedItems.length > 0) {
          $.post(
            `https://${GetParentResourceName()}/buyitemsBank`,
            JSON.stringify({ items: app.addedItems })
          );
        }
      };
    },
    sellCash: function () {
      return () => {
        if (app.addedItems.length > 0) {
          $.post(
            `https://${GetParentResourceName()}/sellitemsCash`,
            JSON.stringify({ items: app.addedItems })
          );
        }
      };
    },
    sellBank: function () {
      return () => {
        if (app.addedItems.length > 0) {
          $.post(
            `https://${GetParentResourceName()}/sellitemsBank`,
            JSON.stringify({ items: app.addedItems })
          );
        }
      };
    },
    iconChange: function () {
      return (e) => {
        e.target.src = "./images/empty.png";
      };
    },
  },
  methods: {
    findItemByName: function (name) {
      return this.addedItems.find((item) => item.name === name);
    },
    handleNotificationClick: function (event) {
      $.post(`https://${GetParentResourceName()}/action`, JSON.stringify({
        action: {
            event: event,
        }
    })
      );
    },
    handleAction(action) {
      if (!this.canClick || this.isTyping || this.chatCoolDown) {
        return false;
      }

      this.canClick = false;
      this.chatHistory.push({ type: "text", left: true, data: action.text });
      this.chatCoolDown = true;

      $("#chat-history").animate(
        {
          scrollTop: $("#chat-history")[0].scrollHeight,
        },
        500
      );
      console.log(JSON.stringify(action));

      setTimeout(() => {
        $.post(
          `https://${GetParentResourceName()}/action`,
          JSON.stringify({ action: action })
        ).done((bool) => {
          if (bool) {
            setTimeout(() => {
              this.chatCoolDown = false;
              this.canClick = true;
            }, 800);
          }
        });
      }, 700);
    },
    typeMessage(message, callback) {
      this.isTyping = true;
      this.canClick = false;
      let currentIndex = 0;
      const messageLength = message.length;

      if (!this.chatHistory[this.chatHistory.length - 1].left) {
        $.post(`https://${GetParentResourceName()}/onTypingStart`);
      }

      const type = () => {
        if (currentIndex < messageLength) {
          this.chatHistory[this.chatHistory.length - 1].data =
            message.substring(0, currentIndex + 1);
          currentIndex++;
          setTimeout(type, this.config?.Chat?.TypeSpeed || this.typingSpeed);
        } else {
          this.isTyping = false;
          this.canClick = true;

          if (!this.chatHistory[this.chatHistory.length - 1].left) {
            $.post(`https://${GetParentResourceName()}/onTypingEnd`);
          }
          if (callback) callback();
        }
      };

      type();
    },
    handleFollowUp(options) {
      this.actionsList = options.map((option) => ({
        text: option.text,
        event: option.event,
        serverSide: option.serverSide,
        args: option.args,
        followUp: option.followUp,
      }));
    },
    selectFirstButton() {
      const questTexts = document.querySelectorAll(".quest-text");
      if (questTexts.length > 0) {
        // Remove active class from all buttons
        questTexts.forEach((element) => {
          element.classList.remove("active");
        });

        // Add active class to first button
        const firstButton = questTexts[0];
        firstButton.classList.add("active");

        // Get the arrow element
        const svgElement = document.getElementById("arrow");

        // Calculate center position based on first button
        const rect = firstButton.getBoundingClientRect();
        const centerY = rect.top + window.scrollY + rect.height / 2 - 10;

        // Update arrow position
        svgElement.style.top = `${centerY}px`;
      }
    },
  },
  watch: {
    addedItems: {
      handler: function (newVal, oldVal) {
        this.totalPrice = 0;
        this.addedItems.forEach((item) => {
          this.totalPrice += item.price * item.count;
        });
      },
      deep: true,
    },
    actionsList: {
      handler(newVal) {
        if (newVal && newVal.length > 0) {
          this.$nextTick(() => {
            this.selectFirstButton();
          });
        }
      },
      deep: true,
    },
  },
});

function addChat(data) {
  if (data.type === "text") {
    app.chatHistory.push({
      type: "text",
      data: "",
      left: data.left !== undefined ? data.left : false,
    });
    app.typeMessage(data.data);
  } else if (data.type === "notification") {
    app.chatHistory.push({
      type: "notification",
      data: [{
          title: data.data[0].title,
          message: data.data[0].message,
          options: data.data[0].options,
          Clickevent: data.data[0].Clickevent,
          icon: data.data[0].icon,
          serverSide: data.data[0].serverSide
      }]
  });
  } else {
    app.chatHistory.push(data);
  }

  $("#chat-history").animate(
    {
      scrollTop: $("#chat-history")[0].scrollHeight,
    },
    1000
  );
}

function mouseDown(e) {
  document.querySelectorAll(".quest-text").forEach((element) => {
    element.classList.remove("active");
  });
  const svgElement = document.getElementById("arrow");
  const rect = e.target.getBoundingClientRect();
  const centerY = rect.top + window.scrollY + rect.height / 2 - 10;
  svgElement.style.top = centerY;
  e.target.classList.add("active");
}

window.addEventListener("message", (event) => {
  switch (event.data.action) {
    case "openUI":
      // Store config
      app.config = event.data.config;
      app.addedItems = [];
      app.chatHistory = [];
      app.totalPrice = 0;
      app.display = true;
      app.chatCoolDown = true;
      setTimeout(() => {
        app.chatCoolDown = false;
      }, app.config?.Chat?.CoolDown || 1500);
      app.name = event.data.name;
      app.SellItem = event.data.SellItem;
      app.BuyItem = event.data.BuyItem;
      app.actionsList = event.data.options;
      for (let i = 0; i < app.SellItem.length; i++) {
        app.SellItem[i].count = 0;
      }
      for (let i = 0; i < app.BuyItem.length; i++) {
        app.BuyItem[i].count = 0;
      }
      setTimeout(() => {
        addChat({ type: "text", data: event.data.dialog, left: false });
      }, 500);
      break;
    case "setFollowUpOptions":
      // Wait for any previous messages to complete
      setTimeout(() => {
        app.actionsList = event.data.options
          .map((option) => {
            // Validate each option
            if (!option) {
              console.error("Invalid option:", option);
              return null;
            }

            return {
              text: option.text || "No text provided",
              event: option.event || "",
              serverSide: option.serverSide || false,
              args: option.args || {},
              followUp: option.followUp || [],
            };
          })
          .filter((option) => option !== null); // Remove any invalid options

        console.log("Processed options:", app.actionsList);
      }, app.config?.Chat?.CoolDown || 1500);
      break;
    case "addMessage":
      event.data.type = event.data.stype;
      addChat(event.data);
      break;
    case "closeUI":
      app.display = false;
      break;
    case "addBuy":
      app.addedItems = [];
      app.chatHistory = [];
      setTimeout(() => {
        addChat({ type: "buy", data: app.BuyItem });
      }, 200);
      break;
    case "addSell":
      app.addedItems = [];
      app.chatHistory = [];
      setTimeout(() => {
        addChat({ type: "sell", data: app.inventoryItems });
      }, 200);
      break;
    case "notification":
      addChat({
        type: "notification",
        data: [{
            title: event.data.title,
            message: event.data.message,
            options: event.data.options,
            Clickevent: event.data.Clickevent,
            icon: event.data.icon,
            serverSide: false
        }]
    });
      break;
    case "successItems":
      let removedItems = app.addedItems;
      addChat({ type: "add", data: app.addedItems });
      app.addedItems = [];
      break;
    case "deleteItems":
      addChat({
        type: "remove",
        data: [
          { label: "Received Money", name: "money", count: event.data.price },
        ],
      });
      app.addedItems = []; // Clear addedItems after successful sale
      break;
    case "setInventoryItems":
      app.inventoryItems = [];

      if (event.data.items && Array.isArray(event.data.items)) {
        const itemGroups = event.data.items.reduce((groups, invItem) => {
          if (!invItem || !invItem.name) return groups;

          const itemName = invItem.name.toLowerCase();
          if (!groups[itemName]) {
            groups[itemName] = {
              name: invItem.name,
              max: 0,
            };
          }
          groups[itemName].max += invItem.count || invItem.amount || 0;
          return groups;
        }, {});

        Object.values(itemGroups).forEach((groupedItem) => {
          if (!groupedItem || !groupedItem.name) return;

          const npcItem = app.SellItem.find(
            (item) =>
              item &&
              item.name &&
              item.name.toLowerCase() === groupedItem.name.toLowerCase()
          );

          if (npcItem) {
            app.inventoryItems.push({
              name: npcItem.name,
              label: npcItem.label,
              max: groupedItem.max,
              count: 0,
              price: npcItem.price,
            });
          }
        });
      }
      break;
    default:
      break;
  }
});

$(function () {
  document.onkeyup = function (data) {
    if (data.which === 27) {
      app.display = false;
      $.post(`https://${GetParentResourceName()}/closeUI`);
    }
  };
});
