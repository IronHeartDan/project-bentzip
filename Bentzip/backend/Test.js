(function () {
  const touristList = {
    items: [
      {
        name: "gaurav",
        gender: "female",
        nation: "indian",
        documentType: "aadhar",
        idNo: "0510",
      },
      {
        name: "jatan",
        gender: "male",
        nation: "indian",
        documentType: "pancard",
        idNo: "9166",
      },
      {
        name: "mayur",
        gender: "male",
        nation: "indian",
        documentType: "aadhar",
        idNo: "4262",
      },
      {
        name: "amol",
        gender: "male",
        nation: "indian",
        documentType: "drivinglicence",
        idNo: "7713",
      },
    ],
  };
  const submitInterval = 7000,
    rowInterval = 7000;

  const setData = async (touristList) => {
    localStorage.setItem("touristArr", JSON.stringify(touristList));
    const parseData = JSON.parse(localStorage.getItem("touristArr"));
    console.log(parseData.items);
    const listArr = parseData.items;
    fillRow(listArr, submitInterval, rowInterval);
  };

  localStorage.removeItem("touristArr");

  setData(touristList);
})();

//  (function () {
//   const zoneNo = 8,
//     bookingDate = 0,
//     vehicleType = "gypsy",
//     fillTimeout = 1200,
//     submitInterval = 7000,
//     rowInterval = 7000;

//   const loadScript = (src) => {
//     return new Promise((resolve) => {
//       const script = document.createElement("script");
//       script.src = src;
//       script.onload = () => {
//         resolve(true);
//       };
//       script.onerror = () => {
//         resolve(false);
//       };
//       document.body.appendChild(script);
//     });
//   };

//   async function callLoadScript() {
//     const isLoad = await loadScript(
//       "https://ranthambhoretigersafari.in/js/jquery-file.js"
//     );
//     console.log(isLoad);
//     if (isLoad) {
//       fillBookingZone(
//         zoneNo,
//         bookingDate,
//         vehicleType,
//         fillTimeout,
//         submitInterval,
//         rowInterval
//       );
//     } else {
//       alert("Click again to fill information");
//     }
//   }
//   callLoadScript();
// })();
