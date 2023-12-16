export async function findDesc() {

  let dataFilters = {
    'language': [],
    'settlement': [],
    'repository': [],
    // 'origDate': [],
    'scriptNote': [],
    'handNote_script': [], 
    'objectType': [],
    'creation-origPlace': [],
    'creation-date': []
  };


  try {
    // wait for a response including the set and editions
    const { msSets } = await loadAllEditions();

    const processUrlPromises = [];
    // make modifications to create the right format of the url
    for (const { msSet, msEdition } of msSets) {
      const xmlFilePath = `/fileadmin/user_upload/manuscripts/${msSet}/${msEdition}.xml`;
      processUrlPromises.push(fetchAndParseXML(xmlFilePath, dataFilters));
    }

    await Promise.all(processUrlPromises);
    return(msSets)

  } catch (error) {
    throw error;
  }
}

// fetch from server

function fetchAndParseXML(xmlFilePath,dataFilters) {
  const xhr = new XMLHttpRequest();
  xhr.onreadystatechange = function () {
    if (xhr.readyState === XMLHttpRequest.DONE) {
      if (xhr.status === 200) {
        const xmlString = xhr.responseText;
        const parser = new DOMParser();
        const xmlDoc = parser.parseFromString(xmlString, 'text/xml');

        // Loop through keys in dataFilters
        for (const key in dataFilters) {
          // if the key exists in the XML file
          if (Object.hasOwnProperty.call(dataFilters, key)) {
            if (key.includes('_')) {
              // If the key contains '_', split into node name and attribute name
              const [nodeName, attributeName] = key.split('_');
              // retrieve the node name
              const nodes = xmlDoc.getElementsByTagName(nodeName);

              for (let i = 0; i < nodes.length; i++) {
                // retrieve the value of the attribute within the specific node
                let attributeValue = nodes[i].getAttribute(attributeName);
                // manipulate the value if necessary
                attributeValue = clearText(key, attributeValue)
                if (attributeValue && attributeValue!== 'Unknown' && !dataFilters[key].includes(attributeValue)) {
                  // push the attribute value as the value of the key-node in the dataFilters object
                  dataFilters[key].push(attributeValue);
                  // create the html entry
                  addOptionToSelect(attributeValue,key+'Options')
                }
              }
            } else if (key.includes('-')) {
              // If the key contains '-', split into parent node name and target node name
              const [nodeName, targetName] = key.split('-');
              const nodes = xmlDoc.getElementsByTagName(nodeName);

              for (let i = 0; i < nodes.length; i++) {
                const targetNode = nodes[i].querySelector(targetName);
                
            
                if (targetNode) {
                  let targetValue = targetNode.textContent;
                  targetValue = clearText(key, targetValue);
                  if (targetValue && targetValue !== 'Unknown' && !dataFilters[key].includes(targetValue)) {
                    dataFilters[key].push(targetValue);
                    addOptionToSelect(targetValue, key + 'Options');
                  }
                }
              }
            }
            else {
              // Standard handling for non-nested elements
              const nodeList = xmlDoc.getElementsByTagName(key);

              for (let i = 0; i < nodeList.length; i++) {
                let nodeValue = nodeList[i].textContent;
                nodeValue = clearText(key, nodeValue)
                if (nodeValue!== 'Unknown' && !dataFilters[key].includes(nodeValue)) {
                  dataFilters[key].push(nodeValue);
                  addOptionToSelect(nodeValue,key+'Options')
                }
              }
            }
          }
        }
      } else {
        console.error(`Error fetching ${xmlFilePath}. Status code: ${xhr.status}`);
      }
    }
  };

  xhr.open('GET', xmlFilePath, true);
  xhr.send();
}


// create the check option in the HTML
function addOptionToSelect(optionText, selectId) {
  const select = $('#' + selectId);

  const option = $('<option>').attr({
    value: optionText
  }).text(optionText);

  select.append(option);
}


function clearText(doc, text) {
    const pattern =  /[A-Z]/;
    
if (doc === 'scriptNote'){
    const textlist = text.split(/[,]/)
    const matchingElements = textlist.map((element) => {
      element = element.trim()

      if (pattern.test(element[0]))
      {
        return element
      }
    })
    .filter(Boolean)
    return matchingElements.join(', ');

  } else {
      return text
    }
  }

  
  async function loadAllEditions() {
    try {
      // Get an array of all available msSet values from the dropdown menu ('middle karaim')
      const msSets = Array.from(
        $("form#ms-search-form select#searchMsSet option:not(:first-child)"),
        (option) => option.value.toLowerCase()
      );
  
      // Wait for all the AJAX requests to complete and return their results as an array
      const results = await Promise.all(
        // Create an array of AJAX requests
        msSets.map(async (msSet) => {
          const editions = await $.ajax({
            method: "GET",
            url: "/selectorhelper",
            data: { msSet },
          });
  
          // Pair each set with its corresponding edition(s)
          return { msSet, msEdition: editions };
        })
      );
  
      // Flatten the array so that the final result is a single-level array of all the responses
      const flattenedResults = results.flatMap((entry) =>
        entry.msEdition.map((edition) => ({ msSet: entry.msSet, msEdition: edition }))
      );
      return { msSets: flattenedResults };

  } catch (error) {
    showToastr("error", "Could not load editions. Please try again!");
    throw error;
  }
}