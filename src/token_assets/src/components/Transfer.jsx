import React, { useState } from "react";
import {Principal} from '@dfinity/principal';
import {token} from "../../../declarations/token";

function Transfer() {
  
  const [recipientID,setID] = useState("");
  const [amount,setAmount] = useState("");
  const [isDisabled,setDisable] = useState(false);
  const [feedback,setFeedback] = useState("");
  const [isHidden,setHidden] = useState(true);

  async function handleClick() {
    setDisable(true);
    const recipient = Principal.fromText(recipientID);
    const amountToTransfer = Number(amount);
    const result = await token.transfer(recipient,amountToTransfer);
    setFeedback(result);
    setHidden(false);
    setDisable(false);
  }

  return (
    <div className="window white">
      <div className="transfer">
        <fieldset>
          <legend>To Account:</legend>
          <ul>
            <li>
              <input
                type="text"
                id="transfer-to-id"
                value={recipientID}
                onChange={(e) => setID(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <fieldset>
          <legend>Amount:</legend>
          <ul>
            <li>
              <input
                type="number"
                id="amount"
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <p className="trade-buttons">
          <button id="btn-transfer" 
          disabled={isDisabled}
          onClick={handleClick} >
            Transfer
          </button>
        </p>
        <p hidden={isHidden}>{feedback}</p>
      </div>
    </div>
  );
}

export default Transfer;
