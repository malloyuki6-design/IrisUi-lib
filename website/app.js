const components=[
  "Window","Tab","Section","Accordion","Label","Paragraph","Divider","Button","Toggle",
  "Dropdown","MultiDropdown","ImageDropdown","Slider","Input","Keybind","ColorPicker",
  "Image","Avatar","Card","Loading","Progress","Status","Badge","KeyValue","Alert",
  "CodeBlock","Modal","ContextMenu","Tooltip","Search","Notification"
];

const list=document.getElementById("component-list");
components.forEach(name=>{
  const node=document.createElement("span");
  node.className="chip";
  node.textContent=name;
  list.appendChild(node);
});

const copy=document.getElementById("copy");
copy.addEventListener("click",async()=>{
  const value=document.getElementById("snippet").innerText;
  let copied=false;
  try{
    if(navigator.clipboard&&window.isSecureContext){
      await navigator.clipboard.writeText(value);
      copied=true;
    }
  }catch(_){}
  if(!copied){
    const area=document.createElement("textarea");
    area.value=value;
    area.style.position="fixed";
    area.style.opacity="0";
    document.body.appendChild(area);
    area.focus();
    area.select();
    try{copied=document.execCommand("copy")}catch(_){}
    area.remove();
  }
  const old=copy.textContent;
  copy.textContent=copied?"Copied":"Copy failed";
  setTimeout(()=>copy.textContent=old,1100);
});
