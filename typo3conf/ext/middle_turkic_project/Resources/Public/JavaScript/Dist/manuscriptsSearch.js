import * as msUtils from './msUtils.js';


export function highlightSearchTerm(url) {
    
    const params = new URLSearchParams(url.split('?')[1]);
    const searchTerm = params.get('search');
    const previous = params.get('prev');

    const previousWords = previous ? previous.split('%20') : [];
    const following = params.get('following');

    const followingWords = following ? following.split('%20') : [];
    let totalCount = 0

    
    const observeTdElements = () => {
      const tbodyElement = document.querySelector('#msTranscriptContent tbody');
      const tdElements = tbodyElement ? tbodyElement.querySelectorAll('td') : [];
  
      if (tdElements.length > 0) {
        const tbodyElement = document.querySelector('#msTranscriptContent tbody');
        const tdElements = tbodyElement.querySelectorAll('td');
        // consider both uppercase and lowercase with 'gi'
        const searchRegex = new RegExp(`\\b${searchTerm}\\b`, 'gi');


        tdElements.forEach((tdElement) => {

            const tdText = removeNumbersFromString(tdElement.innerText.trim());
            const tdHTML = tdElement.innerHTML.trim();
            const textWords = tdText.split(' ');
            const searchTermIndex = textWords.findIndex((word) => searchRegex.test(word));
            const prevWordIndex = searchTermIndex - 1;
            const nextWordIndex = searchTermIndex + 1;
            const prevWord = textWords[prevWordIndex];
            const nextWord = textWords[nextWordIndex];
            const lastWordIndex = textWords.length - 1;
            const secondLastWordIndex = textWords.length - 2;
      

            const punctuationMarks = '{}()[]⸢⸣⟨⟩<>⸤⸥';
            // check if the string in the page is enclosed in punctuation marks
            const punctRegex = new RegExp(`[${punctuationMarks.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&')}]`);
            const containsPunctuation = punctRegex.test(textWords[searchTermIndex]);

            const isMatched = textWords[searchTermIndex] && (textWords[searchTermIndex].toLowerCase() === searchTerm || textWords[searchTermIndex]===searchTerm +'.' || containsPunctuation || textWords[searchTermIndex].toLowerCase() === searchTerm+'.')
            
          
          // we do that so we don't need to loop if the searchterm or part of it does not exist in the line
              if (isMatched) {

            // if search term in last position and previous word in url and text
              if ((searchTermIndex === lastWordIndex && previous === prevWord) 
              // if search term in last position and following word in url is a dot + previousword undefined
              || searchTermIndex === lastWordIndex && (following === '.') && prevWord === undefined && (textWords[searchTermIndex].includes('.'))
              // or second from last position and previous and following word in url and text
              || (searchTermIndex === secondLastWordIndex && previous === prevWord && following === nextWord )
              // if one previous word in url == previous word in text + following token in url is a dot
              || (previous === prevWord)  && (following === '.')  && (textWords[searchTermIndex].includes('.'))
              // if one previous word in url == previous word in text + following token in url is a comma
              || (previous === prevWord) && (following === ',')  && (textWords[searchTermIndex].includes(','))
              // if previous word in text is undefined and no previous in url and following in url is a dot
              || textWords[searchTermIndex].includes('.') && prevWord === undefined && !previous && (following === '.')
              // if previous word in text = previous word in url and search term in last position
              || textWords[searchTermIndex].includes('.') && prevWord === previous && searchTermIndex === lastWordIndex
              // if one previous and one following word in url and text
              || (previous === prevWord) && (following === nextWord)
              // if two previous words in url and text
              || previousWords.length !== 0 && previousWords[0].includes(' ') && previousWords.every((word) => tdText.replace(/\s+/g, ' ').includes(word))
              // if two following words in url and text
              || followingWords.length !== 0 && followingWords[0].includes(' ') && followingWords.every((word) => tdText.replace(/\s+/g, ' ').includes(word))
              // if one following word in url and text
              || (prevWord === undefined  && !previous && following === nextWord)
              // if the search term in the text is enclosed in punctuation marks
              || (containsPunctuation && !previous && !following && !textWords[searchTermIndex].includes('-'))
              // if previous in url = previous in text and no following in url but following in text
              || (previous === prevWord && !following && nextWord)
              // if no previous and no following
              || (!previous && !following  && containsPunctuation)
              )

              {   
                const highlightedText = tdHTML.replace(searchRegex, '<span class="highlight">$&</span>');
                  tdElement.innerHTML = highlightedText;
                  totalCount += 1
                  
              // for other instances of the search term in the page    
              } 
              else { 
                  const markedText = tdHTML.replace(searchRegex, '<mark>$&</mark>');
                  tdElement.innerHTML = markedText;
                  totalCount += 1

            }
            
          }
        });


      const element = document.getElementById('counting');
      element.innerHTML = "Chapter results: " + totalCount
      element.style.display = "block";

      // Stop observing once the td elements are available
      observer.disconnect();
      }
    };

  // Create a MutationObserver to observe changes in the DOM
  const observer = new MutationObserver(observeTdElements);
  observer.observe(document.documentElement, { childList: true, subtree: true });

  // Call the observeTdElements function immediately to check if the td elements are already available
  observeTdElements();
  searchHighChapter()
}


function searchHighChapter() {
    const chapterURL = /\/(\d+)\?/;
    const currentURL = document.URL
    const match = currentURL.match(chapterURL);
    const number = match && match[1];
    

    const firstDiv = document.querySelector('#msNavBar');
    const activeTabPane = firstDiv.querySelector(".tab-pane.active");
    const navLinkList = activeTabPane.querySelectorAll(".ms-nav-2nd .nav-link");
    const lastNavLink = navLinkList[navLinkList.length - 1];
    const dataChapterNo = lastNavLink.getAttribute('data-chapterno');

    // select book number
    const activeBook = firstDiv.querySelector(".dropdown-toggle.active");
    const bookNum = activeBook.getAttribute('data-bookno')

    // select chapter number
    const chapterPaneActive = activeTabPane.querySelector('.ms-nav-2nd');
    const activeChapter = chapterPaneActive.querySelector('.nav-link.active');
    const chapterNum = activeChapter.getAttribute('data-chapterno')


    // const chapterNumInputs;
    const chapterNumInputs = document.querySelectorAll(".ms-selector-form input[type='number'][id$='chapterNum']");
    const chapterFormGroups = document.querySelectorAll(".ms-selector-form [id$='chapterFormGroup']");
      
    for (let i = 0; i < chapterFormGroups.length; i++) {
        chapterFormGroups[i].classList.remove("d-none");
      }
      
    for (let i = 0; i < chapterNumInputs.length; i++) {
        chapterNumInputs[i].setAttribute('min', 1);
      }
    
    for (let i = 0; i < chapterNumInputs.length; i++) {
      chapterNumInputs[i].setAttribute('max', dataChapterNo);
      chapterNumInputs[i].setAttribute('placeholder', number);
      chapterNumInputs[i].setAttribute('size', Math.floor(Math.log10(dataChapterNo)) + 1);
    }
    msUtils.updateNavigation(bookNum,chapterNum)
  }

  function removeNumbersFromString(str) {
    return str.replace(/\d+\b/g, '');
  }