# Claude Certified Associate – Foundations (CCAO-F)
## Question Bank 1 — Answer Key & Revision Notes

**Score:** 29 / 70 (41.4%) · 9 incorrect · 32 skipped (accuracy on attempted: 29/38 = 76.3%)  
**Missed:** 9 questions — [Q5](#question-5), [Q9](#question-9), [Q13](#question-13), [Q21](#question-21), [Q36](#question-36), [Q41](#question-41), [Q62](#question-62), [Q63](#question-63), [Q64](#question-64)

> Every question lists its correct answer. Full explanations are included **only for missed questions** (marked ❌). Skipped questions (⏭️) show the correct answer only. Key concepts to revise for the weak topics are in the [Revision Notes](#revision-notes) section at the end.

## Contents
- [Score by domain](#score-by-domain)
- [Questions & answers](#questions--answers)
- [Revision notes](#revision-notes)

## Score by domain

| Domain | Correct | Incorrect | Skipped | Total | Score | Missed |
|---|---:|---:|---:|---:|---:|---|
| Responsible Use, Data Protection, and Governance | 3 | 2 | 7 | 12 | 25% | [Q21](#question-21), [Q62](#question-62) |
| Capability, Model, and Context Selection | 3 | 3 | 4 | 10 | 30% | [Q9](#question-9), [Q13](#question-13), [Q41](#question-41) |
| Output Evaluation and Quality Control | 5 | 2 | 7 | 14 | 36% | [Q36](#question-36), [Q63](#question-63) |
| Workflow Design and Integration | 5 | 1 | 7 | 13 | 38% | [Q5](#question-5) |
| Task Definition and Prompting | 5 | 1 | 5 | 11 | 45% | [Q64](#question-64) |
| Configuration and Knowledge Management | 8 | 0 | 2 | 10 | 80% | — |

## Questions & answers

### Question 1

✅ Answered correctly · *Capability, Model, and Context Selection*

A scholarship officer at a community foundation uses Sonnet at its default effort level to produce first-pass scores for applications against a five-part rubric. The scores are decision support only: she is the trained reviewer who makes every award decision, and applicants are told that AI assists the review. Her spot checks of thirty earlier scores agreed with her own judgment, and about 200 applications remain this week. Today one application received an unexpectedly low score; its transcripts come from two schools with different grading scales, and its essay answers two rubric parts together. Which action best fits this situation?

- Rescore this application with Haiku at a low effort level, because a fast second score is a low-cost way to confirm whether the first was right.
- Keep the current settings for routine applications, and rescore this one at a higher effort level, because its unusual details need more thorough work. ✅
- Switch to Opus at the Max effort level for this application and all remaining ones, because scholarship decisions need the most capable settings available.
- Accept the low score as it is, because thirty matching spot checks show that Sonnet at its default effort level scores this rubric reliably.

**Correct answer:** Keep the current settings for routine applications, and rescore this one at a higher effort level, because its unusual details need more thorough work.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 2

✅ Answered correctly · *Task Definition and Prompting*

A safety coordinator at a roofing contractor asks Claude to summarize the state heat-safety rule that took effect two months ago, for a one-page briefing to site supervisors. Web search is still off from an earlier task that used only her own files. Three differently worded prompts, all on Sonnet, each return a confident summary with no sources that describes the older rule she already knows. Which next step is most likely to produce a usable summary?

- Rewrite the prompt with a workplace-safety specialist role and details about the roofing crews, since more context usually improves a weak summary.
- Switch from Sonnet to Opus and raise the effort level, so Claude reasons more carefully about which version of the rule applies today.
- Tell Claude in the same chat that its summary describes the older rule, and ask it to correct each requirement to the current version.
- Turn on web search and repeat the request, asking Claude to cite a source for each requirement so that she can check it. ✅

**Correct answer:** Turn on web search and repeat the request, asking Claude to cite a source for each requirement so that she can check it.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 3

✅ Answered correctly · *Responsible Use, Data Protection, and Governance*

A benefits manager at a furniture manufacturer checks the quarter's Claude use against the company AI policy. The policy says a qualified person who can change the result must review each Claude-drafted recommendation on a tuition reimbursement request. A temporary office assistant reads every recommendation carefully, but has not learned the eligibility rules and may correct only wording. Four denials were later reversed on appeal. Which corrective action is most likely to fix this problem?

- Assign the review to a benefits specialist who knows the eligibility rules and can change a recommendation before each decision goes to the employee. ✅
- Give the office assistant a one-page checklist of the eligibility rules and keep the current review step, so that weak recommendations are noticed earlier.
- Switch to a more capable model and raise the effort level, so that the recommendations are more accurate before the office assistant reads them.
- Ask Claude to recheck each recommendation against the eligibility rules and add a confidence note, so the office assistant knows which ones to question.

**Correct answer:** Assign the review to a benefits specialist who knows the eligibility rules and can change a recommendation before each decision goes to the employee.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 4

✅ Answered correctly · *Responsible Use, Data Protection, and Governance*

A business development coordinator at an architecture firm is collecting files so that Claude can help draft a capabilities brochure in the firm's approved workspace. Firm policy sets three levels: published or anonymized material may be used freely, internal material that names people or relates to unannounced work needs a manager's review first, and client material under a confidentiality agreement stays out of Claude. When it is unclear which level a file belongs to, the stricter level applies. Which two actions are consistent with the policy? (Select TWO.)

- Upload the team résumés, which list names and phone numbers, and ask Claude to remove the personal details before it drafts any text.
- Ask the manager to review the draft design brief for a museum project that is not yet announced, and upload it only if the manager approves. ✅
- Upload the project case studies taken from the firm's public website without asking for a review, because they are already published material. ✅
- Upload a client's site survey that is under a confidentiality agreement in an incognito chat, since incognito chats are kept out of history and memory.
- Treat a cost report whose source cannot be confirmed as published material and upload it, because nothing in the file marks it as confidential.

**Correct answers:** Ask the manager to review the draft design brief for a museum project that is not yet announced, and upload it only if the manager approves. <br>**+** Upload the project case studies taken from the firm's public website without asking for a review, because they are already published material.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 5

❌ **Answered incorrectly** · *Workflow Design and Integration*

A knowledge manager at an architecture firm proposes that architects use Claude with the Google Drive connector to draft building-code checklists from project folders. Web search is off on the firm's account. One partner with little AI experience fears Claude will read the HR and finance folders, which architects cannot open. Another partner assumes Claude already knows the code amendments the city adopted last month. Which two statements should the manager make? (Select TWO.)

- Say that the connector opens the firm's whole Drive to Claude, so HR and finance folders must move to a separate system before the rollout.
- Say that the connector lets Claude reach only the Drive files the signed-in architect can already open, so HR and finance folders stay closed to it. ✅ *(your answer)*
- Say that Claude may not know last month's amendments on its own, so architects will add the adopted text and check each checklist item against it. ✅
- Say that checklists drafted from the firm's own project folders will be accurate, so architects can issue them without checking each item against the code.
- Say that Claude cannot use any rule adopted after its training, even when the text is supplied, so checklists must leave out last month's amendments. ❌ *(your answer)*

**Correct answers:** Say that the connector lets Claude reach only the Drive files the signed-in architect can already open, so HR and finance folders stay closed to it. <br>**+** Say that Claude may not know last month's amendments on its own, so architects will add the adopted text and check each checklist item against it.

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Say that Claude cannot use any rule adopted after its training, even when the text is supplied, so checklists must leave out last month's amendments.*

This statement understates what Claude can do. Claude can read and apply a document that an architect supplies, including a rule adopted after its training. Leaving the amendments out would make the checklists incomplete for no good reason.

**Why the correct answer is right** — *Say that Claude may not know last month's amendments on its own, so architects will add the adopted text and check each checklist item against it.*

Claude's built-in knowledge can be out of date, and web search is off on this account, so Claude may not know a rule adopted last month. Giving Claude the adopted text lets it use the current rule. An architect still checks each item because Claude can misread a source and the architect is responsible for the checklist.

**Overall explanation**

People with little AI experience often make two opposite mistakes. They expect Claude to see or know more than it does, or they expect it to be able to do less than it can. A good explanation states what Claude can reach, what it knows, what it can do with supplied material, and which human check stays in place.

A connector such as Google Drive uses the permissions of the person who signed in. Claude can retrieve the files that person can already open, and nothing more. In this firm, architects cannot open the HR and finance folders, so Claude cannot reach them in an architect's session. Telling the partner this is accurate. Telling the partner that the whole Drive is open to Claude is wrong, and it would lead the firm to move folders for no reason. Note the limit of the claim: if the firm later gives an architect access to a sensitive folder, Claude can reach that folder in that architect's session too, so the firm's Drive sharing settings still matter. See [Use connectors to extend Claude's capabilities](https://support.claude.com/en/articles/11176164-use-connectors-to-extend-claude-s-capabilities).

Claude's built-in knowledge can be out of date. It can be wrong or confused about recent events, and it can state an old rule with confidence. Web search is off on the firm's account, so Claude has no way to look up an amendment adopted last month. The accurate message is that Claude may not know the amendment unless an architect supplies the adopted text. Claude can read and apply a supplied document, so the claim that it cannot use any rule adopted after its training understates what it can do. See [Claude is providing incorrect or misleading responses](https://support.claude.com/en/articles/8525154-claude-is-providing-incorrect-or-misleading-responses-what-s-going-on).

The human check stays in every version of this workflow. Drafting from the firm's own folders reduces errors but does not remove them, because Claude can misread a file or leave out a detail. The architect is responsible for the checklist, so the architect compares each item with the code before the checklist is issued. Stakeholders trust an AI-assisted workflow more when this review step is named clearly, and less when someone promises accuracy that the first visible error will disprove.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 6

✅ Answered correctly · *Configuration and Knowledge Management*

A student services coordinator at a community college shares a Project that six advisors use to draft weekly reminder emails. The Project instructions limit each email to 150 words and require the advising office hours at the end. This week, the coordinator must also send one email about a one-time change to registration deadlines, which needs about 400 words and a table of dates. The advisors will keep drafting regular reminders all week. Which approach should the coordinator take?

- Ask Claude to remember that deadline emails can run to 400 words with a table, so that memory carries the exception into later chats.
- Edit the Project instructions to allow a 400-word email with a table of dates, then restore the original rules once the deadline email is sent.
- Leave the Project instructions unchanged, and state in the request for this email that it is an exception needing about 400 words and a table. ✅
- Create a second Project whose instructions allow longer emails with tables of dates, and draft the registration deadline email there this week instead.

**Correct answer:** Leave the Project instructions unchanged, and state in the request for this email that it is an exception needing about 400 words and a table.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 7

⏭️ Skipped · *Workflow Design and Integration*

A member insights analyst at a grocery cooperative is mapping the quarterly survey workflow. Claude sorts about 6,000 comments into twelve themes, and the theme counts go into a report that the merchandising committee uses to set priorities. Last quarter, several comments about parking were counted under prices. Labels can be corrected until the report is issued, and sorting by hand used to take a week. The team has marked the sorting step human-reviewed. Which review design fits this step?

- Ask Claude to read its labels a second time and correct any that are wrong, then record the step as reviewed before the report is issued.
- Read all 6,000 comments and confirm or correct every label before the report is issued, because the committee sets its priorities from the theme counts.
- Compare each theme's count with last quarter's count, and check labels only in a theme whose count changed sharply, because large changes suggest sorting errors.
- Check a random sample of comments from each theme against Claude's labels, and re-sort any theme with repeated errors before the report is issued. ✅

**Correct answer:** Check a random sample of comments from each theme against Claude's labels, and re-sort any theme with repeated errors before the report is issued.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 8

⏭️ Skipped · *Responsible Use, Data Protection, and Governance*

A communications lead at a credit union checks the quarter's Claude use against the AI policy, which makes the person who sends member-facing content accountable for its accuracy. An analyst drafted the monthly newsletter with Claude, and a coordinator sent it with an auto loan rate that did not match the published rate sheet. The analyst assumed the coordinator would check the figures; the coordinator checked only the layout, saying Claude wrote the numbers. Which corrective action is most likely to fix this problem?

- Have the analyst attach the rate sheet when drafting, so that Claude takes each rate from the source file instead of generating it.
- Add a statement to each newsletter saying that AI assisted with the draft, so that members know to confirm any rate before relying on it.
- Make clear that the sender owns every figure, and add a step where the sender checks each rate against the rate sheet before sending. ✅
- Add a line to the drafting prompt telling Claude to confirm each rate it writes, and to note in the draft that the figures were verified.

**Correct answer:** Make clear that the sender owns every figure, and add a step where the sender checks each rate against the rate sheet before sending.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 9

❌ **Answered incorrectly** · *Capability, Model, and Context Selection*

Four grant writers at a community health nonprofit draft sections of funding applications every week. Each writer works in standalone chats and pastes in the program descriptions and the writing rules from a personal copy. Drafts now use different program names, and one writer's copy describes a program that changed in the spring. Their Claude plan lets members share Projects with colleagues, and the director reviews each application. Which change best fits this work?

- Create one Project shared with all four writers that holds the current program descriptions and writing rules, so every draft starts from the same material. ✅
- Have each writer build a private Project with a copy of the program descriptions and writing rules, so that nobody has to paste them into each chat again. ❌ *(your answer)*
- Have all four writers select Opus and raise the effort level, so that the drafts apply program names and writing rules more consistently across the team.
- Have each writer turn on memory and tell Claude to remember the program descriptions and writing rules, so every new chat begins with that background.

**Correct answer:** Create one Project shared with all four writers that holds the current program descriptions and writing rules, so every draft starts from the same material.

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Have each writer build a private Project with a copy of the program descriptions and writing rules, so that nobody has to paste them into each chat again.*

This removes the repeated pasting, which is an improvement on the current setup. It still leaves four separate copies that each writer must update, and the outdated program description shows that separate copies stop matching over time.

**Why the correct answer is right** — *Create one Project shared with all four writers that holds the current program descriptions and writing rules, so every draft starts from the same material.*

The work repeats every week, the background is the same for all four writers, and the drafts differ because each person uses a separate copy. A shared Project gives the team one set of instructions and knowledge files, so when a program changes, the file is updated once and every writer gets the change.

**Overall explanation**

The team's problem is not the quality of any single draft. Four people each work from a personal copy of the same background, and the copies have started to differ. A **Project** holds instructions and knowledge files that every conversation inside it starts from. When a Project is shared with colleagues, everyone with access works from that one set of instructions and files. The program descriptions belong in the Project knowledge and the writing rules belong in the Project instructions. When a program changes, one person replaces one file and all four writers get the update.

A private Project for each writer would stop the repeated pasting, which is a real improvement. The team would still have four copies to keep current, and the writer whose copy missed the spring change shows how quickly separate copies stop matching. **Memory** has the same weakness, because it belongs to each person's own account. It is useful for bringing one person's background, such as role and preferences, into new chats. It does not give a team one shared source.

Choosing Opus or a higher effort level changes how much reasoning goes into each response. Responses take longer and count more against usage limits. The material Claude is given stays the same, so a writer who pastes an old program description will get a well-written draft about the old program. When the same setup produces different results for different people, check what each person is giving Claude before changing the model.

A shared Project still needs maintenance. Someone on the team must be responsible for the files and replace them when programs change. Drafts will also vary from one run to the next, so the director's review stays in the workflow. For more detail, see [How can I create and manage projects?](https://support.claude.com/en/articles/9519177-how-can-i-create-and-manage-projects) and [Use Claude's chat search and memory to build on previous context](https://support.claude.com/en/articles/11817273-use-claude-s-chat-search-and-memory-to-build-on-previous-context).

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 10

⏭️ Skipped · *Capability, Model, and Context Selection*

An events coordinator at a botanical garden keeps a Project for the spring plant sale. Its knowledge holds the site map and the vendor list, and its memory holds only the sale date. Last week, in one chat in the Project, she and Claude settled the opening hours, three ticket prices, and the parking plan. Today, in a new chat in the Project, a draft of volunteer instructions guesses at the hours and parking. She will draft about a dozen more documents for the sale. Which action best fits this work?

- Write all the remaining sale documents in last week's chat, since that thread already holds the settled hours, prices, and parking plan in full.
- Paste the settled hours, prices, and parking plan at the start of today's chat, and repeat that step in every later chat for the sale.
- In last week's chat, ask Claude to summarize the settled hours, prices, and parking plan, check the summary, then add it to the Project's knowledge. ✅
- Switch today's chat to Opus and raise the effort level, so Claude reasons more carefully about the hours, prices, and parking plan settled in the earlier chat.

**Correct answer:** In last week's chat, ask Claude to summarize the settled hours, prices, and parking plan, check the summary, then add it to the Project's knowledge.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 11

⏭️ Skipped · *Responsible Use, Data Protection, and Governance*

A sales manager at a home solar installer receives a spreadsheet that a new hire copied from a former employer, a competitor, without that company's permission. It lists 2,000 of the competitor's customers with names, home addresses, phone numbers, and monthly energy bills. The manager proposes that Claude use code-executed analysis to rank which households the sales team should call first. The operations director asks for a classification. Which classification is the best fit?

- Appropriate with normal review: ranking sales leads is reversible and low in consequence, and the manager checks the list before any calls are made.
- Inappropriate: choosing which people to contact needs human judgment, so a salesperson should rank the copied list by hand and Claude should not.
- Inappropriate: the list was taken without permission and the households never agreed to this use, so the manager should report it and not upload it. ✅
- Appropriate with safeguards: replace names, addresses, and phone numbers with codes before uploading, so Claude ranks the households without seeing who they are.

**Correct answer:** Inappropriate: the list was taken without permission and the households never agreed to this use, so the manager should report it and not upload it.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 12

⏭️ Skipped · *Output Evaluation and Quality Control*

A procurement analyst uses Claude with web search to summarize a new packaging regulation for a memo that the leadership team will use to decide on a supplier change this week. The summary reads clearly and shows source links for four of its claims. The compliance deadline and the maximum penalty amount appear with no link. So far, the analyst has only read the summary itself. Which action should the analyst take before sending the memo?

- Switch to Opus at a higher effort level, regenerate the summary, and keep the deadline and penalty amount only if the new answer repeats both of them.
- Ask Claude to rate its confidence in each claim, keep only the claims it rates as high confidence, and record those ratings in the memo.
- Remove the deadline and penalty amount because they have no links, and send the other four claims as written since each one has a source link.
- Open each linked source to check that it supports its claim, and confirm the deadline and penalty amount against the regulator's published text. ✅

**Correct answer:** Open each linked source to check that it supports its claim, and confirm the deadline and penalty amount against the regulator's published text.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 13

❌ **Answered incorrectly** · *Capability, Model, and Context Selection*

A budget analyst at a city water utility uses Claude for many unrelated tasks, in standalone chats and in two Projects. Memory is on and correctly holds her role and her manager's name. In almost every new chat she retypes two facts: the utility's fiscal year starts in October, and amounts should be shown in thousands of dollars. Her memory has no saved topic for either fact. Which action best fits her needs?

- Create a new Project for her budget work and add both facts to its instructions, so that every chat started inside it begins with them. ❌ *(your answer)*
- Keep one long standalone chat open for all of her tasks, since the two facts she typed at the start will remain in that conversation.
- Tell Claude in a standalone chat to remember both facts, then check in her memory settings that the saved topic states them correctly. ✅
- Ask Claude at the start of each new chat to search her past chats for both facts, since many earlier conversations already contain them.

**Correct answer:** Tell Claude in a standalone chat to remember both facts, then check in her memory settings that the saved topic states them correctly.

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Create a new Project for her budget work and add both facts to its instructions, so that every chat started inside it begins with them.*

Project instructions apply only to chats inside that one Project. Her standalone chats and her two existing Projects would not get the facts, so she would still retype them for most of her work.

**Why the correct answer is right** — *Tell Claude in a standalone chat to remember both facts, then check in her memory settings that the saved topic states them correctly.*

The two facts are short, stay true, and apply to all of her work, so memory is the place that reaches every new standalone chat and, by default, her chats inside Projects as well. She can tell Claude directly what to remember without waiting for it to save the facts by itself. Reading the saved topic in settings confirms the wording is right before it affects later chats.

**Overall explanation**

Three places can hold background that Claude should start from: one conversation, a Project, and **memory**. Each one reaches a different amount of work. A conversation holds only what was said in it. A Project's instructions and knowledge apply only to chats inside that Project. Memory from chats outside Projects is used in new standalone chats, and by default it is also used alongside a Project's own memory when the user works inside a Project (unless "Use account memory" is turned off on that Project's page).

The analyst's two facts are short, they stay true, and they apply to all of her work, not to one area of work. That is the case for memory. Claude saves memory topics by itself as she chats, but it has not saved these two facts, and she does not have to wait. She can tell Claude what to remember, and the update applies to her next conversation. Opening her memory in settings afterward lets her read the saved topic and edit it if the wording is wrong. This check matters because a wrong topic would affect every later chat. Memory reduces retyping, but she should still check the fiscal year and the number format in each deliverable. See [Use Claude's chat search and memory to build on previous context](https://support.claude.com/en/articles/11817273-use-claude-s-chat-search-and-memory-to-build-on-previous-context).

The other actions each cover only part of her work. A new Project with the facts in its instructions helps only the chats started in that Project, as described in [How can I create and manage projects?](https://support.claude.com/en/articles/9519177-how-can-i-create-and-manage-projects). Her standalone chats and her two existing Projects would still need the facts typed in. One long chat for unrelated tasks fills the context window (the amount Claude can keep in view in one conversation). Earlier messages can be summarized as the chat grows, so details typed at the start can have less effect, and material from one task can appear in another (see [How do usage and length limits work?](https://support.claude.com/en/articles/11647753-how-do-usage-and-length-limits-work)). Searching past chats can find the facts where that feature is available, but she must ask in every new chat, and a search started inside a Project covers only that Project's conversations.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 14

✅ Answered correctly · *Workflow Design and Integration*

A facilities analyst at a private university runs a monthly building energy report in a shared Project. Claude uses code execution to total costs from a metering system export. Last month a system update split the single cost column into separate electricity and gas columns. Claude totaled only electricity without comment, and the low figures reached the budget committee. A colleague takes over next month. Which change best protects the workflow?

- Add a final step to each run that asks Claude to confirm the totals are correct, so that errors are caught before the report is sent.
- Switch the Project's chats to a more capable model and a higher effort level, so that Claude reasons more carefully about each month's export.
- List the expected export columns in the Project instructions, and tell Claude to stop and report any difference before it calculates the totals. ✅
- Have the colleague recalculate every building's total by hand in a spreadsheet each month, so that the report no longer depends on Claude's calculations.

**Correct answer:** List the expected export columns in the Project instructions, and tell Claude to stop and report any difference before it calculates the totals.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 15

⏭️ Skipped · *Capability, Model, and Context Selection*

A freelance market researcher worked only for a toy company for two years, in standalone chats with memory on. That contract has ended, and she now works for a pharmacy chain. She reviewed her memory and found that almost every topic describes the toy company's products, staff, and report rules; the few others are easy to restate. Her first drafts for the pharmacy chain use the toy company's terms. She wants memory to learn her new work. Which action best fits her situation?

- Pause memory in her settings, so that the toy company topics stay saved but are no longer used in her drafts for the pharmacy chain.
- Delete her old chats about the toy company, so that the topics built from those chats are removed from memory along with them.
- Reset memory in her settings, which permanently deletes every saved topic, then let memory build again from her new work. ✅
- Tell Claude at the start of each new chat to ignore the toy company, so that each draft uses only the pharmacy chain's terms.

**Correct answer:** Reset memory in her settings, which permanently deletes every saved topic, then let memory build again from her new work.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 16

⏭️ Skipped · *Task Definition and Prompting*

A benefits administrator at a trucking company must explain two new health plan options to drivers and warehouse staff. The company offered only one plan before, so most of them have never compared plans. The insurer's summary uses terms such as coinsurance and out-of-pocket maximum. Her draft prompt attaches the summary and says, "You are a benefits specialist. Write a one-page explanation of the two plan options, with a heading for each." Which addition to the prompt is most likely to produce a usable first draft?

- Select Opus and raise the effort level before sending the prompt, so that Claude reasons more carefully about how to explain the insurer's plan summary.
- Change the role to a senior benefits consultant with 20 years of experience, so that Claude explains the two plan options with more expertise and authority.
- State that the readers are drivers and warehouse staff who have never compared health plans, so that Claude explains each insurance term in everyday words. ✅
- Add the sentence "Keep the explanation clear, simple, and easy to follow" at the end, so that Claude knows the page should not be difficult to read.

**Correct answer:** State that the readers are drivers and warehouse staff who have never compared health plans, so that Claude explains each insurance term in everyday words.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 17

⏭️ Skipped · *Workflow Design and Integration*

A finance manager at a freight forwarding company is mapping the monthly board reporting workflow. An analyst spends two days building the cash-flow summary from the ledger export, and the map marks the step human-retained because the board sets spending limits from it. In a three-month trial, Claude used code execution on the same export and produced the same totals in under an hour. The manager approves every board report package before it is sent. How should the manager classify this step?

- AI-executed: Claude builds the summary and it goes directly into the package, because code execution calculates each total and matched the analyst's totals for three months.
- Human-retained: the analyst keeps building the summary without Claude, because the board sets spending limits from these figures and a wrong total would be costly.
- Human-reviewed: Claude builds the summary, and the manager checks its totals against the ledger before approving the package, because an error can still be fixed then. ✅
- Human-retained: the analyst keeps building the summary, and Claude compares it with the ledger export afterward, because a second check lowers the chance of a wrong total.

**Correct answer:** Human-reviewed: Claude builds the summary, and the manager checks its totals against the ledger before approving the package, because an error can still be fixed then.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 18

⏭️ Skipped · *Workflow Design and Integration*

A finance operations lead at an engineering consultancy is reviewing the expense workflow. Claude compares each expense line with the written travel policy and marks it "within policy" or "over limit". An approver then approves each report and reads mainly the lines marked "over limit". The marks for meals, mileage and hotel rates have been accurate. This quarter, Claude marked a visa fee and a spouse's flight change, which the policy does not mention, as "within policy", and both were paid. Which change should the lead make?

- Have the approver read every line of every report against the policy before approving it, because Claude's marks have now been shown to contain errors.
- Add a third mark for expenses the policy does not clearly cover, and have the approver decide each of those, because they need a person's judgment. ✅
- Switch the policy check to a more capable model and raise the effort level, because unusual expenses need deeper reasoning than routine ones do.
- Add rules for visa fees and family flight changes to Claude's instructions, because Claude can mark these expenses correctly once each rule is written down.

**Correct answer:** Add a third mark for expenses the policy does not clearly cover, and have the approver decide each of those, because they need a person's judgment.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 19

✅ Answered correctly · *Output Evaluation and Quality Control*

Last month, a contracts analyst at a food distributor uploaded a 48-page supplier agreement and saved Claude's two-page summary without checking it against the agreement. Today she pastes that summary into a new chat and asks for a memo on price increases. The memo's terms, a 4 percent yearly cap and 60 days' notice, match the summary. The purchasing director will set next year's budget from the memo. Which action should the analyst take before sending the memo?

- Open the supplier agreement, find the price-adjustment clause, and confirm that the cap and notice period in the memo match its wording. ✅
- Upload the agreement to the chat, ask Claude for a new summary, and send the memo if the new summary gives the same price terms.
- Switch to Opus at a higher effort level, regenerate the memo from the saved summary, and send it if the price terms are unchanged.
- Send the memo as written, since both of its price terms match the saved summary, which Claude produced from the full agreement last month.

**Correct answer:** Open the supplier agreement, find the price-adjustment clause, and confirm that the cap and notice period in the memo match its wording.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 20

✅ Answered correctly · *Configuration and Knowledge Management*

A claims supervisor at an insurance brokerage keeps her own Project for client claim correspondence. Its instructions set the tone, and its knowledge holds the current claims handbook. Her custom Skill for the six-step monthly claims summary also contains a rule to never predict whether an insurer will pay a claim. The summaries follow that rule, but emails and call notes drafted in the Project sometimes predict payment. Which change best fits this setup?

- Use Opus at a higher effort level for emails and call notes, so that Claude reasons more carefully before it writes about a claim's outcome.
- Add the payment rule to the Project instructions, because instructions apply to every chat in the Project, whatever she drafts. ✅
- Add steps for emails and call notes to the Skill, so that Claude also loads the Skill and its payment rule when she drafts those documents.
- Save the payment rule as a one-page file in the Project's knowledge, so that Claude can find it next to the claims handbook.

**Correct answer:** Add the payment rule to the Project instructions, because instructions apply to every chat in the Project, whatever she drafts.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 21

❌ **Answered incorrectly** · *Responsible Use, Data Protection, and Governance*

A grants officer at a community foundation must turn an outline into a slide deck for Friday's board meeting and has built past decks with Anthropic's pre-built PowerPoint Skill. A colleague recommends a third-party Skill with better-looking layouts, from a vendor the foundation has never used. Its description says it also renames, moves, and emails files in connected accounts. The officer's Claude account has Gmail and Google Drive connectors. Which action should the officer take?

- Enable the third-party Skill for this one deck, since a colleague has used it without problems, and disable it as soon as the board deck is finished.
- Leave the third-party Skill disabled and build the deck with the pre-built PowerPoint Skill, because the new Skill does far more than a slide deck needs. ✅
- Enable the third-party Skill but use it only in an incognito chat, because that chat stays out of the officer's chat history and memory after the session.
- Ask the foundation's IT contractor to review the third-party Skill, and build the deck with it once the review confirms that the Skill is safe to enable. ❌ *(your answer)*

**Correct answer:** Leave the third-party Skill disabled and build the deck with the pre-built PowerPoint Skill, because the new Skill does far more than a slide deck needs.

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Ask the foundation's IT contractor to review the third-party Skill, and build the deck with it once the review confirms that the Skill is safe to enable.*

Sending a Skill for review is a good practice when the Skill is useful and no lower-risk tool can do the job. In this situation an Anthropic pre-built Skill already builds the deck, so waiting for a review puts Friday's deadline at risk for a small improvement in layout. Even after approval, the officer would be using a Skill that does more than the task needs.

**Why the correct answer is right** — *Leave the third-party Skill disabled and build the deck with the pre-built PowerPoint Skill, because the new Skill does far more than a slide deck needs.*

A slide deck needs slide building only, and the Anthropic pre-built PowerPoint Skill already does that from a lower-risk source. The third-party Skill comes from an unknown vendor and is described as moving and emailing files in connected accounts, which is much more than this task needs. Declining it removes the risk, and the deck can still be finished by Friday.

**Overall explanation**

A Skill is software. Enabling a third-party Skill makes its bundled instructions available to Claude in the officer's sessions. If connectors such as Gmail and Google Drive are available, those instructions may influence how Claude uses the connected services, within the connector permissions and the action-approval settings on the account. For that reason, a trust check before enabling a Skill asks three questions. **Source:** who published it? **Reach:** what could it affect in the sessions where it will run? **Appropriateness:** is it the right tool for this task, or is it more capability than the task needs? The check can end in one of three results: enable the Skill, escalate it for review, or decline it.

The third-party Skill fails all three questions for this task. The vendor is unknown to the foundation. The officer's account has Gmail and Google Drive connectors, so the Skill's instructions could direct Claude to act on mail and stored files, within the limits of the connector permissions and approval settings. The Skill's own description says it renames, moves, and emails files in connected accounts, and none of those actions is needed to build slides from an outline. Anthropic's guidance is to install Skills only from trusted sources and to review less-trusted ones, including Skills shared by colleagues, because the main risks are prompt injection (hidden instructions that redirect Claude) and data leaving the organization. Anthropic-provided Skills and Skills approved by the organization are the lower-risk starting point, and the pre-built PowerPoint Skill already does this job. Declining the third-party Skill costs only a possible improvement in layout.

Asking for a review is the correct route when a Skill is useful and *no lower-risk tool can do the work*. That is not the case for this deck. A review would delay a deck that is due on Friday, and an approved Skill would still be a broader tool than the task needs. An incognito chat answers a different question: it keeps a conversation out of chat history and memory, but it does not tell the officer what the Skill does. Enabling the Skill for one deck because a colleague recommended it treats a personal recommendation as proof of safety. For as long as the Skill is enabled, its instructions can still influence how Claude uses the Gmail and Google Drive connectors, subject to the connector permissions and approval settings.

See [Use Skills in Claude](https://support.claude.com/en/articles/12512180-use-skills-in-claude) for the difference between Anthropic Skills and custom Skills and for Anthropic's guidance on trusting a Skill before enabling it.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 22

⏭️ Skipped · *Responsible Use, Data Protection, and Governance*

A procurement lead at a regional grocery wholesaler checks the quarter's Claude use against the company AI policy. The policy says supplier pricing agreements may be used only by the six-person procurement team. The lead's Supplier Terms Project holds twelve agreements as knowledge files, and its visibility is set to "public", so everyone in the organization can find and use it. Buyers have never shared a chat from the Project. Which corrective action should the lead take?

- Remind buyers to keep every chat in the Project unshared, since a shared chat would let colleagues outside procurement read the supplier pricing details.
- Run a policy refresher for all staff, so that people outside procurement know they must not open Projects that hold supplier pricing agreements.
- Change the Project's visibility to private and invite only the procurement team, so that nobody outside the team can use the pricing agreements. ✅
- Add a rule to the Project instructions telling Claude to answer supplier pricing questions only when the person asking is on the procurement team.

**Correct answer:** Change the Project's visibility to private and invite only the procurement team, so that nobody outside the team can use the pricing agreements.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 23

⏭️ Skipped · *Output Evaluation and Quality Control*

An operations manager at a regional bakery chain asked Claude to compare two uploaded warehouse leases on rent, term, renewal options, early-exit costs and maintenance duties. Claude returned an eight-page memo with a one-paragraph recommendation at the top. She has checked every figure in the memo against the leases, and all match. The owner will choose and sign one lease on Monday using the memo. Which two actions should the manager take next? (Select TWO.)

- Read the recommendation paragraph against the detailed sections to confirm they agree, because a long memo can state one thing early and another later. ✅
- Send the memo to the owner now, because every figure matched the leases and an internal reader can ask questions before signing the lease on Monday.
- Compare the memo with her five requested topics and both leases to find any term it leaves out, because matching figures cannot show what is missing. ✅
- Regenerate the memo with Opus at a higher effort level and send the new version, because a more capable model handles long leases more carefully.
- Ask Claude in the same chat whether the memo left out anything from either lease, and note its confirmation in the memo, because Claude read both files.

**Correct answers:** Read the recommendation paragraph against the detailed sections to confirm they agree, because a long memo can state one thing early and another later. <br>**+** Compare the memo with her five requested topics and both leases to find any term it leaves out, because matching figures cannot show what is missing.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 24

⏭️ Skipped · *Configuration and Knowledge Management*

An account coordinator at a translation agency drafts client quotes in a private Project. Ten months ago she downloaded the agency's rate card, a Google Doc that the finance lead maintains in Drive, and uploaded that copy to the Project knowledge. This month the finance lead put new per-word rates in the Google Doc, but quotes still show the old rates. The Project instructions cover only layout and tone. Which change to the Project is most likely to keep future quotes on the current rates without a repeated manual step for each quote?

- Switch the Project chats from Sonnet to Opus and raise the effort level, so that Claude reads the rate card more carefully before drafting.
- Paste the new per-word rates into each chat before asking for a quote, so that every draft starts from the numbers the finance lead set.
- Add a line to the Project instructions telling Claude to always apply the newest rate card, since instructions reach every chat in the Project.
- Replace the uploaded copy in the Project knowledge with the rate card added directly from Drive, then draft one test quote to confirm the new rates. ✅

**Correct answer:** Replace the uploaded copy in the Project knowledge with the rate card added directly from Drive, then draft one test quote to confirm the new rates.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 25

⏭️ Skipped · *Task Definition and Prompting*

A volunteer coordinator at a science museum uploads the volunteer handbook and a single document that collects forty feedback notes from new volunteers. She asks Claude in one message to "find the problems with our onboarding, redesign the two-week schedule, and write a new welcome packet." The reply is a polished packet built on a new schedule. It names the problems in two general bullets that cite no notes. The museum director will ask how the schedule changes were chosen. Which revision is most likely to produce a usable result?

- Reply in the same chat asking Claude to add a section that explains how the feedback notes support each change in its new schedule.
- Ask first for a list of onboarding problems tied to the feedback notes, check it, and then request the schedule and the packet. ✅
- Add an opening line asking Claude to act as a senior volunteer-program consultant and to be thorough and rigorous in all three parts.
- Resend the same message with a more capable model and a higher effort level, so that each of the three parts receives deeper reasoning.

**Correct answer:** Ask first for a list of onboarding problems tied to the feedback notes, check it, and then request the schedule and the packet.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 26

⏭️ Skipped · *Output Evaluation and Quality Control*

A sales manager at an industrial equipment distributor turns on web search and asks Claude for a one-page market overview for Thursday's customer presentation. The overview makes seven factual claims. Five have source links, and she has opened each page and confirmed that it supports the claim. The other two, a market growth rate of 6.4 percent and the year a safety standard took effect, have no link. Which action should the manager take for those two claims?

- Look for a reliable published source for the growth rate and for the standard's effective year, and remove whichever claim she cannot confirm. ✅
- Run the request again with Research, and use the new report's versions of the two claims, since Research runs many searches that build on each other.
- Keep both claims as written, since they came from the same web search response as the five claims she has already confirmed against their sources.
- Ask Claude whether the two claims came from pages it found during the search, and keep them if it says that they did.

**Correct answer:** Look for a reliable published source for the growth rate and for the standard's effective year, and remove whichever claim she cannot confirm.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 27

⏭️ Skipped · *Task Definition and Prompting*

A tenant relations manager at a property management company uploads the old and revised versions of a 30-page lease. In one chat, Claude lists each changed clause with its number, groups the changes by tenant type, and drafts a tenant notice. After each step she asks, "Is this complete and correct?", and Claude answers yes. A colleague then finds two clause numbers that are not in the revised lease and one missing change. Which change should the manager make to her checks between steps?

- Check each step's output against the two lease versions herself, opening every cited clause and looking in each section for changes that the list leaves out. ✅
- Stop checking between steps and compare only the finished notice with the revised lease, since the notice contains every change that the earlier steps produced.
- Switch to Opus and raise the effort level for all three steps, so that the answer Claude gives to her question after each step is more reliable.
- Paste each step's output into a new chat with both lease versions and ask Claude to review it for wrong clause numbers and missing changes before continuing.

**Correct answer:** Check each step's output against the two lease versions herself, opening every cited clause and looking in each section for changes that the list leaves out.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 28

⏭️ Skipped · *Workflow Design and Integration*

A member services lead at an electric cooperative runs a Project in which Claude drafts replies to billing disputes from the rate schedule in its knowledge. Specialists copy each draft into the billing system, edit it there, and send it. In each of the three pilot months, specialists edited about one draft in five, usually the payment-plan paragraph. The cooperative's general manager, who has little AI experience, expects Claude to learn from these edits so that review can stop. Which explanation should the lead give?

- Explain that an edit rate that stayed flat for three months shows Claude cannot improve on this task, so specialists should go back to writing every reply themselves.
- Explain that repeated edits mean the task needs a more capable model, so the team will switch to Opus at a higher effort level and end review once edits become rare.
- Confirm that Claude improves as it drafts more replies in the Project, and propose that specialists check only one reply in ten once the edit rate starts to fall.
- Explain that Claude does not see edits made in the billing system, so the team will add the recurring fixes to the Project instructions and keep reviewing every reply. ✅

**Correct answer:** Explain that Claude does not see edits made in the billing system, so the team will add the recurring fixes to the Project instructions and keep reviewing every reply.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 29

⏭️ Skipped · *Output Evaluation and Quality Control*

A development analyst at a regional theater company uploads a spreadsheet of last year's gifts, with donor names replaced by codes. She asks Claude to use code execution to find the average gift from individual donors. The treasurer will present this figure to the board. Claude returns \$412.60 and notes that it averaged all 2,310 rows in the file. The analyst knows that 140 of those rows are corporate sponsorships. What should the analyst do with the figure?

- Have Claude run the same calculation a second time and use the figure if both runs match, because two matching results confirm that it is accurate.
- Treat the figure as needing revision: have Claude recalculate using only individual donor rows, then check the number of rows used against the file. ✅
- Use the figure in the report as it is, because code execution ran the calculation on the actual file and the result is therefore trustworthy.
- Keep the figure and add a footnote saying that it includes corporate sponsorships, so that the treasurer can allow for the difference when presenting it.

**Correct answer:** Treat the figure as needing revision: have Claude recalculate using only individual donor rows, then check the number of rows used against the file.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 30

⏭️ Skipped · *Workflow Design and Integration*

A dealer support lead at a kitchen-appliance maker runs a Project in which Claude drafts answers to dealers' warranty questions from the warranty terms in its knowledge. A specialist reviews every draft before it is sent. In a six-week pilot of 300 drafts, Claude added an "I am not certain" note to 12 drafts. Specialists found 9 wrong answers, and 6 of them had no note. The operations director, who has little AI experience, suggests reviewing only drafts that carry the note. Which explanation should the lead give?

- Explain that Claude can state a wrong answer as confidently as a correct one, so specialists will keep reviewing every draft, with or without a note. ✅
- Explain that a new Project instruction will make Claude note every answer it is unsure of, so specialists can then review only the noted drafts.
- Explain that Claude adds a note when it is unsure of an answer, so specialists can review only those drafts and send the others to dealers.
- Explain that six wrong drafts without a note show Claude is not reliable for warranty questions, so specialists will write every answer themselves again.

**Correct answer:** Explain that Claude can state a wrong answer as confidently as a correct one, so specialists will keep reviewing every draft, with or without a note.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 31

✅ Answered correctly · *Capability, Model, and Context Selection*

A customer care lead at a home appliance maker must mark 280 complaints from last month as either a possible safety incident or routine. The company's definition is one paragraph, and customers write vague phrases such as "got very hot" or "smelled odd". The safety team reads only complaints marked as possible incidents, and a missed incident can delay a legally required report. The marking is due in three days. Which selection should the customer care lead make?

- Use Sonnet at a low effort level for all 280 complaints, then ask Claude in that chat to confirm that no incident was missed.
- Use Haiku at a low effort level for all 280 complaints, because sorting short items into two groups is high-volume work that needs speed.
- Use Opus at its default effort level for all 280 complaints, because the vague wording needs judgment and one missed incident is costly. ✅
- Use Haiku at a low effort level for all 280 complaints, then use Opus to check only those that Haiku marked as possible incidents.

**Correct answer:** Use Opus at its default effort level for all 280 complaints, because the vague wording needs judgment and one missed incident is costly.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 32

⏭️ Skipped · *Responsible Use, Data Protection, and Governance*

A customer care lead at a water utility proposes that Claude sort 30,000 overdue accounts into two groups using payment history and neighborhood. One group would be offered payment plans; the other would receive shutoff warnings. The team disagrees about whether using neighborhood is fair. The utility's AI policy does not mention sorting customers, and its AI governance committee reviews new use cases on request. Which action should the lead take first?

- Remove neighborhood from the sorting, classify the use as appropriate with safeguards on the team's own authority, and have a team member check a sample of accounts.
- Write down who is affected, what could go wrong, and the open fairness question, then send the proposal to the governance committee before any sorting begins. ✅
- Classify the use as appropriate and start the sorting, since the AI policy contains no rule against grouping customers and the team can adjust the groups later.
- Ask Claude whether sorting by neighborhood is fair and compliant with the AI policy, then record its answer as the documented rationale for the team's classification.

**Correct answer:** Write down who is affected, what could go wrong, and the open fairness question, then send the proposal to the governance committee before any sorting begins.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 33

⏭️ Skipped · *Capability, Model, and Context Selection*

A member services representative at a pension fund answers phone calls with Claude open. During a call she asks short questions about the uploaded plan booklet, such as which section covers early withdrawal, and she confirms each answer in the booklet before telling the member. She is still using Opus at the High effort level, left over from earlier work, and the menu for this model shows no Thinking toggle. The answers are correct on the first response but slow, and callers wait. Which two actions fit these lookups? (Select TWO.)

- Keep the current settings and save the questions until each call ends, because accuracy matters more than speed when members ask about their pensions.
- Choose a lower effort level for the lookups, because on a model with no Thinking toggle, effort is the setting that makes Claude think less. ✅
- Switch to Haiku for the lookups, because each question is short and narrow, a caller is waiting, and she confirms every answer herself. ✅
- Raise the effort level to Max for the lookups, because a more thorough first answer removes the need for any follow-up question during a call.
- Keep Opus at High for the lookups, because a more capable model finishes each task in fewer turns and is therefore faster per call.

**Correct answers:** Choose a lower effort level for the lookups, because on a model with no Thinking toggle, effort is the setting that makes Claude think less. <br>**+** Switch to Haiku for the lookups, because each question is short and narrow, a caller is waiting, and she confirms every answer herself.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 34

⏭️ Skipped · *Output Evaluation and Quality Control*

An outreach coordinator at a county library system uploads a description of a new evening program and asks Claude for a promotion plan aimed at the typical card holder. Claude describes this person as a parent in their thirties, which matches what she sees at her own branch, and every channel in the plan targets parents. The patron survey, which she did not upload, reports card holders by age group and branch. Which action should the coordinator take before the director sets the outreach budget from the plan?

- Compare the profile with the patron survey's age and branch figures, then ask Claude to redo the plan for the groups the survey shows. ✅
- Send the plan to the director as drafted, since the profile is specific and matches the families she sees most often at her own branch.
- Ask Claude whether the profile is an accurate description of the library's card holders, and keep the plan if Claude says that it is.
- Delete the profile paragraph and send the list of channels unchanged, so that the plan makes no claim about who the card holders are.

**Correct answer:** Compare the profile with the patron survey's age and branch figures, then ask Claude to redo the plan for the groups the survey shows.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 35

⏭️ Skipped · *Responsible Use, Data Protection, and Governance*

An account director at a public relations agency checks two months of Claude use against the agency AI policy. The policy says one client's information must never be used in another client's work; it does not mention memory. Account managers draft media plans in ordinary chats and can all state the rule. Since they turned on memory six weeks ago, two drafts have included another client's launch date. Which action should the director take to fix this problem?

- Ask the policy owner to write a new rule about memory, since the current policy does not name the feature and so does not cover this use of it.
- Have account managers delete the memories that hold client details, and set memory controls so one client's information stays out of other chats. ✅
- Repeat the confidentiality training for every account manager, since another client's details in a draft show that the rule is not well understood.
- Add a line to every prompt telling Claude to use only the current client's information, so that details from other accounts are left out of drafts.

**Correct answer:** Have account managers delete the memories that hold client details, and set memory controls so one client's information stays out of other chats.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 36

❌ **Answered incorrectly** · *Output Evaluation and Quality Control*

A guest experience analyst at a hotel group uploads a 30-page guest survey report and asks Claude for a one-page summary for the regional directors. The summary says check-in satisfaction fell from 84 to 75 and that the self-service kiosks installed in March caused the drop. She has confirmed both scores in the report. The directors will use the summary to decide whether to remove the kiosks. Which action should the analyst take before the summary goes to the directors?

- Ask Claude to confirm that the kiosks caused the drop, and add a line to the summary stating that the findings were verified.
- Send the summary as written, since both scores match the report and that shows Claude based the whole summary on the uploaded document. ❌ *(your answer)*
- Check whether the report itself names the kiosks as the cause, and if it does not, remove that statement or label it as unconfirmed. ✅
- Regenerate the summary with a more capable model at a higher effort level, and send that version if it gives the same cause.

**Correct answer:** Check whether the report itself names the kiosks as the cause, and if it does not, remove that statement or label it as unconfirmed.

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Send the summary as written, since both scores match the report and that shows Claude based the whole summary on the uploaded document.*

Matching scores verify only the scores. Claude can copy figures correctly from a document and still add an explanation the document does not contain, written in the same confident tone. The directors will act on the statement about the cause, and nobody has checked it.

**Why the correct answer is right** — *Check whether the report itself names the kiosks as the cause, and if it does not, remove that statement or label it as unconfirmed.*

The cause is a separate claim from the two scores, and nobody has traced it to the report yet. Claude can add an explanation that fits the topic even when the source does not state it. Checking the report for that claim, and removing or labeling it if it is missing, stops an unsupported reason from becoming the basis for the directors' decision.

**Overall explanation**

Claude writes a guess and a supported fact in the same confident voice. A summary of an uploaded document can therefore mix two kinds of statement: statements taken from the document, and statements that Claude added because they fit the topic. The second kind is a **plausible but unsupported claim**. It is hard to notice because nothing about it looks wrong. The kiosks were installed in March and the score fell afterward, so the cause seems reasonable. But a survey can show that a score fell without showing why it fell.

Checking the two scores verified only the two scores. Each claim in an output has to be traced to the source separately, and a cause or an explanation is a claim in the same way a number is. The analyst should open the report and look for a passage that names the kiosks as the cause. If the report says so, the statement can stay. If it does not, she should remove the statement or mark it clearly as a possibility that the report does not confirm. The check is especially important in this case because the directors may remove the kiosks based on this one sentence, and the analyst is responsible for what she sends them.

The other choices do not compare the claim with the source. Matching figures do not show that the rest of the summary came from the report. Asking Claude to confirm its own statement produces another generated answer, not independent evidence, and a note saying "verified" would be untrue. A more capable model or a higher effort level can improve reasoning, but a second summary that repeats the same cause is still not evidence that the report contains it. Anthropic's guidance says that Claude can give responses that look correct but are wrong, and that users should not rely on Claude as a single source of truth: [Claude is providing incorrect or misleading responses. What's going on?](https://support.claude.com/en/articles/8525154-claude-is-providing-incorrect-or-misleading-responses-what-s-going-on)

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 37

✅ Answered correctly · *Responsible Use, Data Protection, and Governance*

A financial aid counselor at a community college proposes a new use for Claude. The scholarship committee would still decide every award and record its reasons. Claude would then turn each record into a plain-language letter telling the student the outcome and the reasons. About 600 letters go out each term, and students have 14 days to appeal. The dean asks for a classification. Which classification is the best fit?

- Inappropriate: scholarship awards affect students' education and finances, so no part of the award process, including the letters, should involve Claude at any stage.
- Appropriate with safeguards: a counselor checks each letter against the committee's record before sending, because Claude explains decisions and does not make them. ✅
- Appropriate with safeguards: Claude rereads each letter in a separate chat and confirms it matches the committee's record, because a separate chat gives an independent check.
- Appropriate without safeguards: the committee has already decided each award, so the letters only repeat its record and can be sent to students as Claude writes them.

**Correct answer:** Appropriate with safeguards: a counselor checks each letter against the committee's record before sending, because Claude explains decisions and does not make them.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 38

✅ Answered correctly · *Output Evaluation and Quality Control*

A visitor services manager at a science museum turns on web search and asks Claude for three attendance benchmarks for a memo to the museum's board, which will use them to set next year's visitor target. Claude returns three figures, each with a source link. She opens the first link. It is a ticketing vendor's blog post, and the figure there counts school-group visits only, not total attendance. Which action should she take before the memo goes to the board?

- Ask Claude to review its three citations, confirm that each figure matches its source page, and add a note to the memo that the benchmarks were verified.
- Open the other two links, confirm that each page supports its figure as used, and replace the first figure with one from an authoritative source. ✅
- Remove the first figure and keep the other two as drafted, because each has a source link that board members can open if they question a number.
- Switch to Opus at a higher effort level and run the same request again, so that Claude chooses stronger sources and reads each page more carefully.

**Correct answer:** Open the other two links, confirm that each page supports its figure as used, and replace the first figure with one from an authoritative source.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 39

⏭️ Skipped · *Workflow Design and Integration*

A quality coordinator at a food-testing laboratory is moving her weekly sample turnaround report into a shared Project that a colleague will run. The Project instructions hold the layout rules, and the document that lists turnaround targets changes once a year. Each report must cover only that week's lab-system export. In a trial, she stored four weekly exports in Project knowledge, and the report counted samples from earlier weeks. Which setup best fits this workflow?

- Run every report in one long chat in the Project, and upload each week's export there so that Claude keeps the layout from earlier weeks.
- Leave the exports in Project knowledge, switch to Opus, and raise the effort level so that Claude separates the weekly figures more carefully.
- Keep only the targets and layout rules in the Project, and upload each week's export in a new chat so that each run is given one export. ✅
- Keep every weekly export in Project knowledge, and state the week to report in each prompt so that Claude selects the matching export.

**Correct answer:** Keep only the targets and layout rules in the Project, and upload each week's export in a new chat so that each run is given one export.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 40

⏭️ Skipped · *Task Definition and Prompting*

A logistics manager at a furniture retailer must write a memo for the owners, who want a fair assessment before deciding whether to keep the in-house delivery trucks or hire an outside carrier. She attaches two years of delivery costs and the carrier's quote, then asks Claude, "Write a memo explaining why the outside carrier is the right choice." The figures match her files, but the memo lists only the carrier's benefits. Which revision is most likely to produce a usable memo?

- Rewrite the request without naming a preferred answer, asking Claude to give the main points for and against each delivery option. ✅
- Add a line telling Claude to act as a senior logistics consultant, then send the same request so the memo shows an expert's judgment.
- Switch to a more capable model and raise the effort level, then send the same request so the analysis considers more of the cost data.
- Reply in the same chat asking Claude to confirm that the memo is balanced and to add a closing paragraph on the carrier's possible risks.

**Correct answer:** Rewrite the request without naming a preferred answer, asking Claude to give the main points for and against each delivery option.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 41

❌ **Answered incorrectly** · *Capability, Model, and Context Selection*

A training manager at a hotel group is trying out a new format for summaries of guest-service workshop feedback, written for regional directors. She has written two summaries in regular chats, each from one workshop's survey export, and she changed the summary's sections after each one. The directors will send more comments over the next month. Only she writes these summaries for now. A colleague suggests building a custom Skill today. Which approach best fits this stage of the work?

- Keep describing the current sections in each chat request while the directors are still commenting, and build a custom Skill once the sections are final. ✅
- Switch to Opus at a higher effort level and ask Claude to choose the best sections, so the format does not depend on further comments.
- Create a Project and add both earlier summaries to its knowledge as examples, so Claude follows their sections whenever she uploads a new survey export. ❌ *(your answer)*
- Build a custom Skill from the current sections today and update it after each round of comments, so every summary follows a packaged procedure.

**Correct answer:** Keep describing the current sections in each chat request while the directors are still commenting, and build a custom Skill once the sections are final.

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Create a Project and add both earlier summaries to its knowledge as examples, so Claude follows their sections whenever she uploads a new survey export.*

The two earlier summaries use different sections, and she has already replaced both layouts. Claude would draw on examples that disagree with each other and with the current format. The background for this work is also not stable yet, so a Project has little background to keep from one chat to the next.

**Why the correct answer is right** — *Keep describing the current sections in each chat request while the directors are still commenting, and build a custom Skill once the sections are final.*

The format has changed after both summaries and more comments are coming, so the procedure is not settled yet. Regular prompting lets her change the sections without creating or maintaining a Skill yet. A Skill is most useful after the directors agree on a final version.

**Overall explanation**

A **Skill** is a packaged procedure that Claude loads when a matching task comes up. It is most useful when the procedure is settled, because the same steps then run every time and nobody has to explain them again. It is much less useful while the task is still changing. The manager changed the sections after both summaries and expects a month of further comments, so the procedure is not settled yet.

Regular prompting fits work that is still being explored. Describing the current sections in each request takes a few lines, and she can change those lines freely after each round of comments. Each summary also depends mainly on that workshop's own survey export, so no stable background needs to carry from one chat to the next. When the directors agree on the final sections, she can package them once as a custom Skill. From then on Claude can apply the format in any chat or Project without her describing it. See [What are skills?](https://support.claude.com/en/articles/12512176-what-are-skills) for how Skills differ from Projects and instructions.

Building the Skill today is not wrong in principle, but it adds maintenance with little benefit. She would have to edit or update the Skill after each round of comments, so every round would add work on top of writing the summary. Adding the two earlier summaries to a Project's knowledge gives Claude two different layouts that she has already replaced, and Claude may mix them or follow the wrong one. Switching to Opus at a higher effort level changes how deeply Claude reasons, at the cost of slower responses and more usage. It does not tell Claude what the directors want, and their comments are what will decide the format.

The order to remember is: settle the procedure first, then package it. Review of each summary stays in her workflow either way, because a Skill reduces variation between runs but does not remove it.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 42

⏭️ Skipped · *Capability, Model, and Context Selection*

A pricing consultant at a management consulting firm is starting four-month engagements with two competing grocery chains. Each chain has supplied confidential pricing files and uses its own terms, and she will work on both every week. Memory is turned on in her account. Firm policy permits this use of Claude but requires that one client's information never appears in the other client's work. Which setup best fits this work?

- Create a single Project for both chains, label every file with the chain's name, and instruct Claude never to use one chain's details in the other chain's work.
- Work in standalone chats with memory turned on, and name the chain at the start of each chat, so Claude applies the right chain's saved details.
- Do all work for both chains in incognito chats and attach the relevant chain's files each time, so nothing is saved to memory or chat history.
- Create one Project per chain with that chain's files and instructions, turn off "Use account memory" in each Project, and work on each chain only there. ✅

**Correct answer:** Create one Project per chain with that chain's files and instructions, turn off "Use account memory" in each Project, and work on each chain only there.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 43

⏭️ Skipped · *Task Definition and Prompting*

An operations manager at a bakery chain will meet an oven supplier on Friday to negotiate the supplier's proposed three-year maintenance agreement. She wants to know which terms to ask the supplier to change. Her draft prompt attaches the 12-page agreement and says, "List the key terms on fees, response times, and cancellation in a table." Which change is most likely to produce a usable first draft?

- Begin the prompt with "You are a world-class contract lawyer with 30 years of experience", so that Claude applies expert judgment to each term.
- Select Opus and raise the effort level before sending the prompt, so that Claude reasons more carefully about fees, response times, and cancellation.
- State that the bakery chain is the customer, and ask Claude to review the agreement as the buyer and mark each term that favors the supplier. ✅
- Add the line "Be thorough and include every clause in the agreement", so that no term she might need on Friday is left out.

**Correct answer:** State that the bakery chain is the customer, and ask Claude to review the agreement as the buyer and mark each term that favors the supplier.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 44

⏭️ Skipped · *Output Evaluation and Quality Control*

A finance coordinator at a county parks department asks Claude to estimate next summer's day-camp budget from an uploaded cost file. Claude replies in the chat with a table of costs and revenue for 400 campers at a \$180 fee, and she has checked the table against the file. The recreation director wants to try other camper numbers and fees herself during a planning meeting on Tuesday. Which format should the coordinator ask Claude for?

- Ask Claude to create a PDF of the checked table with the department's header, so the director receives a finished file that nobody can change by mistake.
- Ask Claude for an Excel file with the camper number and fee as input cells and formulas for the totals, then test it with the checked 400-camper case. ✅
- Ask Claude to add tables to the chat reply for six other combinations of camper number and fee, so the director can compare the totals.
- Have the director ask Claude in the chat for new totals each time she changes a number in the meeting, so every answer is up to date.

**Correct answer:** Ask Claude for an Excel file with the camper number and fee as input cells and formulas for the totals, then test it with the checked 400-camper case.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 45

⏭️ Skipped · *Output Evaluation and Quality Control*

A finance analyst at a staffing agency uploaded 4,200 third-quarter invoices and asked Claude to total revenue by client with code-executed analysis. Company rules exclude canceled invoices from revenue, and the file marks them in a status column. Claude returned client totals and a chart but did not say which rows it counted. The accounting system shows only a company-wide quarter total. The board will set next year's budget from the client figures. Which action should the analyst take before the figures go to the board?

- Confirm how the analysis treated canceled invoices and compare its overall total with the accounting system's quarter total, because computed figures can follow a wrong rule. ✅
- Ask Claude to run the same analysis again in a new chat and send the client figures if both runs match, because identical results confirm that the totals are right.
- Set Claude's analysis aside and manually total all 4,200 invoices by client in a spreadsheet, because a manual calculation removes any doubt about the figures the board will use.
- Send the client totals to the board as returned, because code-executed analysis calculates each figure from the actual invoice rows and the chart agrees with the totals.

**Correct answer:** Confirm how the analysis treated canceled invoices and compare its overall total with the accounting system's quarter total, because computed figures can follow a wrong rule.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 46

⏭️ Skipped · *Responsible Use, Data Protection, and Governance*

A communications consultant at a public relations agency is starting launch plans for two beverage companies that are direct competitors. Each plan will run for about three months and build on earlier drafts. Until now the consultant has done all client work in standalone chats with memory turned on. Agency policy approves the Claude workspace for client material but requires that one client's information never carries into another client's work. Which setup meets the policy and supports the work?

- Keep using standalone chats and open each one by naming the client and telling Claude to ignore anything it remembers about the other client.
- Put both clients in one Project set to private with a knowledge file for each, so that only the consultant can open the client material.
- Create a separate Project for each client, keep that client's chats and files there, and turn off "Use account memory" on each Project page. ✅
- Do the work for both clients in incognito chats, since incognito chats are not saved to chat history or memory and cannot carry anything over.

**Correct answer:** Create a separate Project for each client, keep that client's chats and files there, and turn off "Use account memory" on each Project page.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 47

⏭️ Skipped · *Responsible Use, Data Protection, and Governance*

During a monthly review of Claude use, a billing supervisor at a group of physical therapy clinics learns that a specialist pasted 60 rows of a claims export, with patient names, birth dates, and treatment codes, into an incognito chat last week to find reasons for rejected claims. The specialist keeps memory turned on for other work. Company policy keeps patient records out of the Claude workspace and requires that any breach of this rule be reported to the privacy officer. Which action should the supervisor take first?

- Note in the review that no report is needed, because incognito chats are not saved to chat history or memory and so leave no record of the patient data behind.
- Report the incident to the privacy officer now, because the records were shared and incognito chats are still kept under the organization's retention settings. ✅
- Ask the specialist to open the memory settings and delete every entry that mentions the claims export, so that the patient details cannot appear in any later chats.
- Remind the whole team at the next meeting that patient records must stay out of the Claude workspace, so that the same mistake does not happen a second time.

**Correct answer:** Report the incident to the privacy officer now, because the records were shared and incognito chats are still kept under the organization's retention settings.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 48

⏭️ Skipped · *Configuration and Knowledge Management*

A maintenance planner at a city water utility exports overdue work orders by hand each Monday and writes a summary for her director. She wants Claude to prepare the summary from the work-order system instead. The connector that the utility's IT team approved for that system lets Claude search and read work orders, and also create, reassign, and close them. Field supervisors schedule crews from work-order status. Which setup best fits this workflow?

- Keep every connector tool on and add a Project instruction never to create, reassign, or close work orders, so the rule applies in every chat.
- Keep every connector tool on and decline any approval request to change a work order, because Claude asks before it takes those actions.
- Disconnect the connector and upload a spreadsheet export of the overdue work orders each Monday, so that Claude cannot change anything in the system.
- Turn off the connector's create, reassign, and close tools and keep search and read on, because the summary only needs to read work orders. ✅

**Correct answer:** Turn off the connector's create, reassign, and close tools and keep search and read on, because the summary only needs to read work orders.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 49

⏭️ Skipped · *Workflow Design and Integration*

A visitor services manager at a science museum drafted a weekend staffing plan with Claude. Code-executed analysis of 12 months of ticket-scan records showed an average of 2,300 Saturday visitors, and the plan recommends four more floor staff. The ticketing team now reports that school group scans were counted twice in three of those months and sends a corrected file. The Research findings on peer museums are not affected. Which two actions should the manager take before the plan goes to the director? (Select TWO.)

- Tell Claude that school group scans were counted twice in three months, and ask it to lower the Saturday averages in the plan text by a matching amount.
- Upload the corrected file and have Claude repeat the code-executed analysis, so that the visitor averages come from the corrected records. ✅
- Ask Claude whether a correction of this size is likely to change the staffing recommendation, and keep the plan as drafted if Claude says it is not.
- Ask Claude to list every statement in the plan that depends on the visitor figures, then review whether the staffing recommendation still applies. ✅
- Switch to Opus, raise the effort level, and ask Claude to write the plan again, so that the reasoning behind the staffing recommendation is stronger.

**Correct answers:** Upload the corrected file and have Claude repeat the code-executed analysis, so that the visitor averages come from the corrected records. <br>**+** Ask Claude to list every statement in the plan that depends on the visitor figures, then review whether the staffing recommendation still applies.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 50

✅ Answered correctly · *Workflow Design and Integration*

A service planner at a regional bus agency is preparing a plan for an evening on-demand shuttle. Her confirmed requirements list says the board wants cost per rider and first-year ridership from agencies serving towns under 100,000 people. She asked Research, "How do transit agencies run on-demand shuttles?" The 14-page cited report mostly covers large cities and programs that ended years ago, and gives only two cost figures. Which next step is most likely to produce findings she can use in the plan?

- Ask Claude to cut the current report down to its small-town examples and cost figures, since every source in that report is already cited.
- Switch to Opus, raise the effort level, and run the same question again, since a more capable model will select more relevant agencies and figures.
- Run Research again with a question that states the town size, a recent date range, and the two measures the board wants for each agency. ✅
- Ask Claude in a regular chat to estimate typical cost per rider and ridership for small-town shuttles, since it knows the transit sector well.

**Correct answer:** Run Research again with a question that states the town size, a recent date range, and the two measures the board wants for each agency.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 51

✅ Answered correctly · *Configuration and Knowledge Management*

A client care lead at a veterinary clinic group shares a Project that front-desk staff use to draft replies to pet owners. The Project instructions hold four reply rules followed by the full fee schedule, pasted in as text, and the knowledge holds only a clinic address list. Fees change every quarter. In two recent updates, the person pasting the new fees deleted or changed a reply rule by mistake. Which change is most likely to keep the replies consistent through future fee updates?

- Move the fee schedule into a file in the Project's knowledge, replaced each quarter, and keep only the four reply rules in the instructions. ✅
- Move the reply rules and the fee schedule together into one knowledge file, so that everything the Project relies on is in a single document.
- Keep both in the instructions, add a clear heading above each part, and ask whoever updates the fees to edit only the fee section.
- Remove the fee schedule from the Project, and have each staff member paste the current fees into the request whenever a reply needs them.

**Correct answer:** Move the fee schedule into a file in the Project's knowledge, replaced each quarter, and keep only the four reply rules in the instructions.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 52

✅ Answered correctly · *Configuration and Knowledge Management*

A program manager at a city transit agency keeps her own Project for a year-long fare-system upgrade. Claude needs four kinds of information for this work: the agency's writing rules for board updates, the signed vendor contract, the agency's five-step procedure for building the monthly board update, and a running record of decisions and steering-committee preferences that changes in most weekly planning chats. She wants to restate as little as possible in each chat. Which kind of information is best left to the Project's memory?

- Leave the signed vendor contract to memory, because Claude will keep its terms after she attaches the contract once in an early planning chat.
- Leave the running record of decisions and committee preferences to memory, because it builds up from chat to chat and applies only to this Project. ✅
- Leave the agency's writing rules for board updates to memory, because Claude will learn them from her corrections to the first few drafts in the Project.
- Leave the five-step board update procedure to memory, because Claude will repeat the steps after it has followed them in two or three chats.

**Correct answer:** Leave the running record of decisions and committee preferences to memory, because it builds up from chat to chat and applies only to this Project.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 53

✅ Answered correctly · *Output Evaluation and Quality Control*

A sales consultant at a solar installation company used Claude to draft a proposal for a school district from 12 months of uploaded utility bills and the current price list. The proposal gives a projected annual saving and a payback period, and the school board will vote on the purchase using it. She has not checked those figures and plans to add a footer: "Prepared with AI assistance; figures may contain errors." Which action should the consultant take before sending the proposal?

- Ask Claude to recalculate the saving and the payback period from the uploaded bills, then change the footer to say that the figures have been rechecked.
- Check the projected saving and payback period against the utility bills and price list before sending, because the footer leaves her responsible for both figures. ✅
- Send the proposal with the footer as planned, because a clear notice of AI assistance tells the school board to confirm the figures before it votes.
- Regenerate the proposal with Opus at a higher effort level and keep the footer, because a more capable model makes fewer mistakes when it works with financial figures.

**Correct answer:** Check the projected saving and payback period against the utility bills and price list before sending, because the footer leaves her responsible for both figures.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 54

✅ Answered correctly · *Configuration and Knowledge Management*

A leasing coordinator at a property management company drafts lease summaries in a Project. For seven months, her custom Skill gave every summary the company's four-part layout. For two weeks, summaries have arrived as plain paragraphs, and the steps Claude shows no longer include loading the Skill. Two weeks ago she cleaned up her settings and turned off several items she rarely used. The Skill file and the Project instructions are unchanged. Which check should the coordinator make first?

- Switch to a more capable model and raise the effort level, then regenerate the last two weeks of summaries to see whether the layout returns.
- Copy the four layout steps from the Skill into the Project instructions, so that every chat in the Project receives the layout rules directly.
- Rewrite the Skill with stricter rules for the four-part layout, upload it as a new version, and then request one test summary to compare.
- Confirm in her settings that the Skill is still turned on and that code execution and file creation are enabled, then request one test summary. ✅

**Correct answer:** Confirm in her settings that the Skill is still turned on and that code execution and file creation are enabled, then request one test summary.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 55

✅ Answered correctly · *Task Definition and Prompting*

A billing lead at a commercial laundry company must send a second payment reminder to a hotel whose invoice is 45 days overdue. The hotel has been a customer for nine years, and the owner wants to keep the account. Her draft prompt gives the invoice number, the amount, and a new payment deadline, and says, "Write a payment reminder email, under 120 words." Which addition to the prompt is most likely to produce a usable first draft?

- Open the prompt with a role, such as an experienced collections specialist, so that Claude writes with the judgment of someone who handles overdue accounts.
- Attach the hotel's full invoice and payment records for the nine years, so that Claude can see for itself how reliable the customer has been.
- State that the hotel is a nine-year customer the owner wants to keep, and ask for a tone that is polite but firm about the deadline. ✅
- Add a closing line that asks Claude to make the email professional and well written, so that it reads well to the hotel's accounts team.

**Correct answer:** State that the hotel is a nine-year customer the owner wants to keep, and ask for a tone that is polite but firm about the deadline.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 56

✅ Answered correctly · *Task Definition and Prompting*

An account director at an insurance brokerage has the Google Calendar and Gmail connectors turned on in Claude. Each Friday she sends one request: "Prepare a briefing for my client meetings next week." She updates the briefing during the week, because meetings move and new emails arrive. This week's briefing is clearly written, but it covers four of her six client meetings, and one section summarizes an email thread from a different client with a similar name. Which change to her approach is most likely to produce a briefing she can rely on each week?

- Reply in the same chat asking whether any meetings or emails were missed, and accept the briefing if Claude answers that both sources were fully covered.
- Switch to a more capable model and raise the effort level, then send the same request again so that Claude reads the calendar and inbox more carefully.
- Export next week's calendar and the related email threads by hand, upload the files to a new Project, and ask for the briefing from those files.
- Work in steps: list next week's client meetings from the calendar and check the list, then list each client's Gmail threads and check them, then draft. ✅

**Correct answer:** Work in steps: list next week's client meetings from the calendar and check the list, then list each client's Gmail threads and check them, then draft.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 57

✅ Answered correctly · *Configuration and Knowledge Management*

A project coordinator at a commercial construction company turns on the Google Drive and Gmail connectors and asks Claude for the expected completion date of a clinic renovation. Claude answers March 14. Her Drive holds four versions of the project schedule with similar file names, including the revision the client approved last week, and several emails discuss possible dates. The date will go into a client update this afternoon. Which action should she take first?

- Ask the question again and tell Claude to use only the newest schedule file in her Drive, then put the new answer into the update.
- Ask Claude to confirm that March 14 comes from the most recent schedule, and include the date in the update if Claude says it does.
- Open the citations in Claude's answer to see which file or email the date came from, then compare that source with the approved schedule. ✅
- Switch to a more capable model and a higher effort level, then ask again so that Claude reasons more carefully about which schedule is current.

**Correct answer:** Open the citations in Claude's answer to see which file or email the date came from, then compare that source with the approved schedule.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 58

✅ Answered correctly · *Configuration and Knowledge Management*

A grants manager at a community health nonprofit is preparing a funder report in a chat with the Google Drive connector turned on. Claude finds and summarizes the program narrative and the outcomes tracker from her Drive. It reports that it cannot find the audited financial statement. The finance director keeps that file in a folder shared only with the finance team, which does not include her. Which action is most likely to let Claude use the statement?

- Disconnect the Google Drive connector and connect it again, so that Claude refreshes its view of the Drive and can search the finance team's folder.
- Turn on research and repeat the request, since research runs many searches across the web and her connected tools and is more thorough than chat.
- Ask the finance director for the statement's Google Drive link and paste it into the chat, so that Claude opens the file directly without searching.
- Ask the finance director to share the statement with her Google account, because the connector can reach only the files her own account can open. ✅

**Correct answer:** Ask the finance director to share the statement with her Google account, because the connector can reach only the files her own account can open.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 59

✅ Answered correctly · *Configuration and Knowledge Management*

A tenancy officer at a housing association that uses Claude on a Team plan shares a Project with one colleague for drafting rent-arrears notices. The instructions set a formal, legal tone, and the knowledge holds the tenancy handbook. The association's five-step notice procedure is a custom Skill that she uploaded to her own account. Her notices follow the steps, but her colleague's do not. She also drafts items for the residents' newsletter in this Project, and those items come out formal and quote the handbook. Which two changes should she make? (Select TWO.)

- Ask the organization's Owner to make the notice Skill available to the team, because a Skill belongs to an account and is not shared with the Project. ✅
- Add a line to the Project instructions telling Claude to ignore the tone rules and the handbook whenever a chat is about newsletter items.
- Draft the newsletter items in a separate Project with its own instructions, because this Project's instructions and knowledge apply to every chat in it. ✅
- Turn off "Use account memory" on the Project's page, so that the newsletter chats stay separate from the rent-arrears notices drafted in the same Project.
- Ask the colleague to name the notice Skill at the start of each request, so that Claude loads the five-step procedure for his notices.

**Correct answers:** Ask the organization's Owner to make the notice Skill available to the team, because a Skill belongs to an account and is not shared with the Project. <br>**+** Draft the newsletter items in a separate Project with its own instructions, because this Project's instructions and knowledge apply to every chat in it.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 60

✅ Answered correctly · *Output Evaluation and Quality Control*

A safety coordinator at a food packaging plant has a one-page Claude summary of last quarter's incident log, built around a 12-row table. She has checked it against the log: hand injuries rose from 4 to 9, 7 of the 9 happened during blade changes, and a new glove rule starts Monday. Supervisors will read it aloud at five-minute shift briefings, where workers have no screens or handouts. Which revision best fits this delivery?

- Ask Claude for a two-sentence reminder that hand injuries rose and everyone should take more care, since short general messages are easy to remember.
- Ask Claude to rebuild the summary as an artifact with a cleaner table and bold headings, so supervisors have a well-formatted page to read from.
- Have supervisors read the checked summary aloud as written, including each row of the table, since every detail in it matches the incident log.
- Ask Claude for a short script in plain spoken sentences that gives the rise from 4 to 9, the blade-change finding, and Monday's glove rule. ✅

**Correct answer:** Ask Claude for a short script in plain spoken sentences that gives the rise from 4 to 9, the blade-change finding, and Monday's glove rule.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 61

✅ Answered correctly · *Capability, Model, and Context Selection*

A procurement specialist at a public school district must score five bids for a cafeteria equipment contract. Six weeks ago, in a standalone chat, she and Claude worked out a scoring method with five weighted criteria, and her director approved the weights. She has had many chats since then and does not remember that chat's title. On her paid plan, both research and past-chat search are available. Which action should she take first?

- Switch to Opus at a higher effort level and describe the criteria as she recalls them, so Claude can work out the likely weights.
- Ask Claude in a new standalone chat to find the earlier conversation about bid scoring, then open the cited chat and confirm the weights. ✅
- Create a Project for the cafeteria contract and ask Claude there to find the earlier chat, so the method stays with the contract files.
- Turn on research and ask Claude to locate the scoring method, because research runs many searches and reports its sources with citations.

**Correct answer:** Ask Claude in a new standalone chat to find the earlier conversation about bid scoring, then open the cited chat and confirm the weights.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 62

❌ **Answered incorrectly** · *Responsible Use, Data Protection, and Governance*

A claims analyst at a marine insurance broker is finishing a review of one shipping client's loss records. The loss files are in the knowledge of a private Project shared with two colleagues, and the analyst often rates Claude's replies with the thumbs-up button. The engagement closes Friday. Company policy approves the Claude workspace for client files, requires their removal when an engagement closes, and forbids sharing client content with any vendor for product improvement. Which two actions are consistent with the policy? (Select TWO.)

- Remove the other members from the Project on Friday, so that the loss files stay in its knowledge but only the analyst can open them.
- Stop rating replies in the analysis chats, because a thumbs-up or thumbs-down sends the whole related chat to Anthropic as feedback. ✅
- Delete the loss files from the Project's knowledge on Friday, because files kept there stay available to later chats in the Project. ✅ *(your answer)*
- Keep rating replies in the analysis chats, because chats in a company workspace are not used for model training by default.
- Ask Claude in a final Project chat to forget the loss files and to confirm that no client content remains in the Project. ❌ *(your answer)*

**Correct answers:** Stop rating replies in the analysis chats, because a thumbs-up or thumbs-down sends the whole related chat to Anthropic as feedback. <br>**+** Delete the loss files from the Project's knowledge on Friday, because files kept there stay available to later chats in the Project.

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Ask Claude in a final Project chat to forget the loss files and to confirm that no client content remains in the Project.*

A request in a chat does not delete files from the Project's knowledge, so the files would still be stored after Friday. Claude's statement that nothing remains is also not a check carried out by a person.

**Why the correct answer is right** — *Stop rating replies in the analysis chats, because a thumbs-up or thumbs-down sends the whole related chat to Anthropic as feedback.*

Clicking a rating button submits the related conversation, including the client content in it, as feedback that Anthropic can store and may use for model training. The policy forbids sharing client content with a vendor for product improvement, so the rating buttons should not be used on these chats.

**Overall explanation**

A Project's knowledge is **persistent** storage. A file added there is available as reference in every conversation in that Project until someone deletes it. Closing an engagement does not change this. A rule that client files must be removed at close is met only when the files themselves are deleted from the knowledge. Changing who can open the Project is a different control: it limits *who* can see the files, and the files are still stored. Asking Claude to forget the files changes nothing either, because a reply in a chat does not delete knowledge files, and Claude's statement that nothing remains is not a check carried out by a person. See [Upload files to Claude](https://support.claude.com/en/articles/8241126-upload-files-to-claude) and [Manage project visibility and sharing](https://support.claude.com/en/articles/9519189-manage-project-visibility-and-sharing).

Feedback ratings are a separate way in which content can leave the normal handling of a company workspace. For commercial products such as Claude for Work, Anthropic does not use inputs or outputs to train models by default. Explicit feedback is the exception. When a user clicks the thumbs-up or thumbs-down button, the related conversation, including its content, is submitted as feedback. Anthropic can store it for up to five years and may use it for model training. If that conversation contains client loss records, the rating shares client content with a vendor for product improvement, which the policy forbids. The analyst can still tell colleagues what worked well in other ways; the rating buttons should stay unused on chats that hold client content. See [Is my data used for model training?](https://privacy.claude.com/en/articles/7996868-is-my-data-used-for-model-training).

Each control answers one question. Visibility settings answer who can see the content. Deletion answers whether the content is still stored. Feedback answers whether a conversation is sent to the vendor for improvement work. Read each policy rule, decide which of these questions it asks, and then use the control that answers that question. A true statement about one control, such as the default that commercial chats are not used for training, is not enough to satisfy a rule that depends on a different control.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 63

❌ **Answered incorrectly** · *Output Evaluation and Quality Control*

A quality lead at a furniture manufacturer uploads a returns log and works with Claude for an hour on why returns rose. She has checked the final summary against the log. The summary says "as the second table above shows," uses "Group A" and "Group B" (labels she defined early in the chat for two product lines), and gives no dates. Plant managers will forward it to their supervisors. Which action best prepares the summary for that use?

- Ask Claude to move the summary, unchanged, into an artifact, so it becomes a separate document that she can download and send to all the plant managers. ❌ *(your answer)*
- Ask Claude to revise it so it stands alone: replace the group labels with product names, state the period covered, and include the table it mentions. ✅
- Send the summary as it is and attach the full returns log, so that any supervisor who is unsure can look up the missing details in the data.
- Switch to Opus, raise the effort level, and ask Claude to write the summary again from the log, so the wording is clearer for supervisors.

**Correct answer:** Ask Claude to revise it so it stands alone: replace the group labels with product names, state the period covered, and include the table it mentions.

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Ask Claude to move the summary, unchanged, into an artifact, so it becomes a separate document that she can download and send to all the plant managers.*

An artifact is a good format for a document that will be reused outside the chat, but it only changes where the text is held. The unchanged text would still point to a table that is not in the document, use labels that only she and Claude understand, and give no dates. The content must first be changed so that it does not depend on the chat. Only then can the format help.

**Why the correct answer is right** — *Ask Claude to revise it so it stands alone: replace the group labels with product names, state the period covered, and include the table it mentions.*

Supervisors who receive the forwarded summary never saw the chat, so they cannot see the earlier table, do not know what Group A and Group B mean, and cannot tell which months the figures cover. This revision puts all three inside the summary and does not change the checked findings. She should still compare the revised figures with the checked summary, because a rewrite is new output.

**Overall explanation**

A summary written at the end of a long chat is written for the person who was in that chat. Claude points back to a table earlier in the conversation, reuses short labels the user created, and assumes the reader knows which period the data covers. The quality lead understands all of this. A supervisor who receives the text after it has been forwarded twice has only the text. For that reader, "the second table above" points to nothing, "Group A" has no meaning, and a rise in returns with no dates cannot be acted on.

Editing for an audience includes making the document **self-contained**. Every reference must point to something inside the document. Every label must be a name the reader already uses, such as the product line names. The period and the source of the data must be stated. None of this changes the findings: the figures and conclusions she checked stay the same, and only the way the content is presented changes. After Claude revises the text, she should compare the figures with the version she checked, because any rewrite is new output and can change a number.

Format and content are separate decisions. Anthropic describes artifacts as suited to content that can stand alone without extra conversation context and that is useful outside the chat (see [What are artifacts and how do I use them?](https://support.claude.com/en/articles/17153992-what-are-artifacts-and-how-do-i-use-them)). That is a description of the content, not a result of using the format. Moving unchanged text into an artifact gives her a separate document, but the text inside still depends on the chat. The guidance for Claude Docs makes a related point: a good request states the purpose, the audience, and what the document should cover (see [Get started with Claude Docs](https://support.claude.com/en/articles/16923645-get-started-with-claude-docs)).

Attaching the returns log is a reasonable habit, because readers can check the source. It does not solve this problem, because the labels were defined in the conversation and not in the log, and each reader would have to work out the meaning alone. Changing to Opus and raising the effort level changes how much reasoning goes into the answer. The summary was already accurate, so more reasoning is not what is missing. What is missing is a clear instruction about who will read the summary and what those readers cannot see.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 64

❌ **Answered incorrectly** · *Task Definition and Prompting*

A program manager at a youth soccer league had Claude prepare next season's fee change in four steps in one chat: summarize costs from the uploaded budget, propose three fee options, draft a parent letter, and draft a question-and-answer sheet. The cost summary matches the budget she checked. The letter announces the second option, which Claude called the most balanced. The board, which often adjusts proposals, votes on the options Thursday. Which change should the manager make to the sequence of steps?

- Ask Claude to draft a letter and a sheet for each of the three options, so that a finished set is ready whichever option the board chooses. ❌ *(your answer)*
- Keep the sequence, and ask Claude to explain why the second option is the most balanced, so that the board can read the reasoning.
- Rerun the options step with Opus at a higher effort level, so that the option used in the letter is based on deeper analysis.
- Stop after the three fee options, take them to the board, and request the letter and the sheet after the vote, using the board's choice. ✅

**Correct answer:** Stop after the three fee options, take them to the board, and request the letter and the sheet after the vote, using the board's choice.

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Ask Claude to draft a letter and a sheet for each of the three options, so that a finished set is ready whichever option the board chooses.*

This approach does not depend on Claude's choice, so it lowers the risk. However, it means three times as much drafting and checking, and two of the three sets will not be used. This board often adjusts proposals, so the option it approves may not match any of the three prepared sets.

**Why the correct answer is right** — *Stop after the three fee options, take them to the board, and request the letter and the sheet after the vote, using the board's choice.*

The letter and the question-and-answer sheet both depend on a decision that belongs to the board, and the board has not made it yet. When the manager stops after the options step, a human decision comes before the later steps. The later documents are then based on the real choice, not on an assumption that Claude made so that it could continue.

**Overall explanation**

Breaking a large piece of work into steps works when each step has one action, one output that a person can check, and **no dependency on something that has not happened yet**. The first two steps in this workflow meet that test. The cost summary can be checked against the budget, and the three fee options can be read and compared. The parent letter and the question-and-answer sheet do not meet the test, because both depend on which fee option the league adopts, and the board has not voted.

When a step needs an input that is missing, Claude often supplies a reasonable assumption and continues. That is what happened in this workflow: Claude called the second option the most balanced and wrote the letter around it. The letter reads as finished, so the assumption is easy to miss. A correct cost summary does not help, because when one step passes its check, that tells you nothing about the steps after it.

Checkpoints between steps are not only for checking accuracy. At some checkpoints, a person with authority must make a decision before the work can continue. Setting the fee is the board's responsibility. The sequence should therefore *stop* after the options step, and the options should go to the board. The manager should request the letter and the sheet after the vote, and state the board's choice in the request. This also deals with the fact that the board often adjusts proposals: the later documents are written from what was approved, not from what was proposed.

Asking Claude to explain its preference produces a more convincing argument for an option that the board still has not chosen. Switching to Opus or raising the effort level can make the analysis more detailed, but the problem is the missing decision, not the quality of the reasoning. Drafting a full set for every option is a valid practice, and it does avoid depending on Claude's choice. However, it means three times as much drafting and checking, and an adjusted option would match none of the sets.

Anthropic's guidance on unhelpful answers recommends breaking complex requests into smaller steps and using follow-up requests: [My prompt isn't giving me a helpful answer](https://support.claude.com/en/articles/7996857-my-prompt-isn-t-giving-me-a-helpful-answer).

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 65

✅ Answered correctly · *Workflow Design and Integration*

A compliance lead at a credit union owns a custom Skill that builds the monthly member-complaints summary. She shares it with nine branch managers, and each manager runs the summary in their own branch's Project, which holds that branch's background files. The summaries have matched for a year. From next month, the board wants a new section on unresolved complaints in every summary. Which change best keeps the summaries consistent?

- Send the managers the revised Skill files, and ask each one to upload a personal copy to use in place of the shared Skill.
- Ask each manager to add the new section to their branch Project's instructions, so that every chat in that Project applies it.
- Update the shared Skill to include the new section, so that each manager gets the revised layout the next time they use it. ✅
- Add the new section to her own account-wide instructions for Claude, so that the rule applies wherever the monthly summary is produced.

**Correct answer:** Update the shared Skill to include the new section, so that each manager gets the revised layout the next time they use it.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 66

✅ Answered correctly · *Output Evaluation and Quality Control*

An office manager at an architecture firm asks Claude, in a chat with web search turned off, to draft an updated travel expense guide. She types in the firm's hotel and meal limits, and the draft repeats them correctly. She also asks for the national tax agency's standard mileage rate, which the agency resets each year. The draft states 67 cents per mile. Which action should she take before publishing the guide?

- Ask Claude in the same chat whether 67 cents is still the current rate, and publish the guide if Claude confirms that the figure is correct.
- Check the current mileage rate on the tax agency's own website and correct the draft if the figure differs, because the agency sets the rate. ✅
- Turn on web search, ask Claude for the rate again, and publish whichever figure comes back, because that answer will include a link to its source.
- Switch to Opus at a higher effort level and regenerate the guide, because a more capable model is more likely to state the correct rate.

**Correct answer:** Check the current mileage rate on the tax agency's own website and correct the draft if the figure differs, because the agency sets the rate.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 67

✅ Answered correctly · *Task Definition and Prompting*

A finance coordinator at a veterinary hospital group is building a supplier spending review in four steps and checks each output before moving on. In step two, Claude read an uploaded export of 3,100 invoice lines and stated a yearly total for each of 14 suppliers directly in its reply, showing no calculation. She adds up two suppliers by hand, and both of Claude's totals are a few hundred dollars off. Step three ranks the suppliers by these totals. Which action should the coordinator take next?

- Repeat step two and ask Claude to compute the totals with code-executed analysis, then compare her two manual totals again before step three. ✅
- Repeat step two with Opus at a higher effort level, because a more capable model works through a long list of invoice lines with more care.
- Divide step two into 14 requests, one for each supplier, so that every request covers fewer invoice lines and each total is easier to get right.
- Ask Claude to recheck all 14 totals against the export and confirm that each is correct, then continue to step three once it confirms.

**Correct answer:** Repeat step two and ask Claude to compute the totals with code-executed analysis, then compare her two manual totals again before step three.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 68

✅ Answered correctly · *Task Definition and Prompting*

An events planner at a trade association pastes her notes on fourteen conference venues into a chat and asks Claude to "summarize the capacity, daily rate, parking, catering, and airport distance for each venue." Claude replies with fourteen paragraphs, and the details she checks match her notes. She needs to paste the results into the planning committee's comparison spreadsheet. Which next step is most likely to produce a usable result?

- Switch to a more capable model, raise the effort level, and send the same request again, so that Claude organizes the venue details more carefully.
- Start a new chat and rewrite the whole prompt with an analyst role and background on the committee, so that Claude understands the purpose of the summary.
- Reply in the same chat and ask Claude to present the same details as a table, with one row per venue and one column for each detail. ✅
- Copy each detail from the fourteen paragraphs into the spreadsheet by hand, since the content is already correct and only the layout needs to change.

**Correct answer:** Reply in the same chat and ask Claude to present the same details as a table, with one row per venue and one column for each detail.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 69

✅ Answered correctly · *Workflow Design and Integration*

A membership director at a fitness club chain is preparing a plan to reduce cancellations. The six club managers meet on Monday and are expected to leave with agreed tasks. Claude drafted the plan from a confirmed requirements list, checked Research findings, and code-executed analysis of 18 months of cancellation records. The draft explains accurately why members leave, then ends with a list of eight ideas in no order, with no dates and no person named for each. Which request should the director make next?

- Run Research again to collect more retention examples from other fitness chains, so that the list of ideas in the final section is more complete.
- Ask Claude to turn the findings into recommended actions in priority order, each with a proposed owner, a start date, and the supporting figure. ✅
- Switch to Opus at a higher effort level and regenerate the draft, because a more capable model will produce stronger recommendations from the same material.
- Ask Claude to shorten the draft to a one-page summary with the main charts, so that the managers can read all of it before Monday.

**Correct answer:** Ask Claude to turn the findings into recommended actions in priority order, each with a proposed owner, a start date, and the supporting figure.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 70

✅ Answered correctly · *Workflow Design and Integration*

A leasing operations lead at a property management company built a shared Project that drafts monthly lease-renewal letters from a lease export. The Project instructions hold the letter rules, and a custom Skill she shares sets the layout. For five months only she has run it, and the letters have been correct. Next month eleven property managers will run it for their own buildings, and the letters go to tenants. Which action should the lead take first?

- Tell each property manager to select Opus and a higher effort level in their chats, so that the letters stay correct across eleven different users.
- Expand the Project instructions with more detail on each letter rule, so that the property managers can run the workflow without asking her questions.
- Record a video of herself running the workflow from start to finish, and send it to the eleven property managers before their first run.
- Have two property managers draft letters for their buildings using only what is already set up, then fix each point where they needed her help. ✅

**Correct answer:** Have two property managers draft letters for their buildings using only what is already set up, then fix each point where they needed her help.

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

## Revision notes

Concepts drawn from the 9 missed questions, grouped by domain. **Capability, Model, and Context Selection** had the most misses (3 of 9), so start there.

### 1. Capability, Model, and Context Selection (Q9, Q13, Q41)

#### Where background should live: chat, Project, memory or Skill
| Where | What it reaches | Best for |
|---|---|---|
| **One conversation** | Only that chat | Context for a single task |
| **Private Project** | Chats inside that Project, for one person | One area of work for one person |
| **Shared Project** | Chats inside that Project, for **everyone it's shared with** | A team working from **one shared source** (one file to update) |
| **Memory** | All of **one person's** standalone chats, and by default their Project chats too ("Use account memory" can be turned off per Project) | Short, lasting, personal facts that apply to *all* of your work (role, fiscal year, number format) |
| **Skill** | Any chat or Project where a matching task comes up | A **settled**, repeatable procedure |

- **A team using different copies of the same material (Q9):** use **one shared Project**. Private Projects or memory still leave separate copies that drift apart. Memory belongs to each person's account, so it can't give a team one source.
- **Personal facts you retype everywhere (Q13):** use **memory**. A new Project only helps chats inside it. You can **tell Claude to remember** something, then **check and edit the saved topic in memory settings**, because a wrong topic affects every later chat.
- **A procedure that is still changing (Q41):** keep describing it in each prompt. **Settle the procedure first, then package it as a Skill.** Building the Skill too early means updating it after every round of feedback. Adding old examples to a Project gives Claude outdated layouts it may mix together.
- **Upgrading the model or effort level doesn't fix a context problem.** Opus or a higher effort level means deeper reasoning, slower replies and more usage. It doesn't change the material Claude is given. If the same setup gives different results for different people, **check what each person is giving Claude** before changing the model.
- A shared Project still needs **someone responsible for keeping its files current**, and human review stays in place.

### 2. Responsible Use, Data Protection, and Governance (Q21, Q62)

#### Checking whether to trust a Skill (Q21)
A Skill is software. Once enabled, its instructions can affect how Claude uses your connectors (within connector permissions and approval settings). Ask three questions:
1. **Source:** who published it? Is it Anthropic, approved by your organization, or from an unknown vendor?
2. **Reach:** what could it affect here? Think about which connectors (Gmail, Drive, and so on) are active.
3. **Appropriateness:** does the task need everything it can do?

- There are three possible results: **enable, send for review, or decline**.
- **Decline** when a lower-risk tool (such as Anthropic's pre-built Skill) already does the job. **Send for review** only when the Skill is useful *and no lower-risk tool can do the work*.
- **Main risks:** prompt injection (hidden instructions that redirect Claude) and data leaving the organization.
- Only install Skills from trusted sources. Review less-trusted ones, **including Skills shared by colleagues**.
- Using it only once, or using it in an incognito chat, **doesn't reduce what it can reach**.

#### How data persists and leaves your workspace (Q62)
- **Project knowledge is persistent.** Files stay available to every chat in the Project until someone deletes them. To meet a removal rule, **delete the files**.
- Removing members only limits **who can see** the files; the files are still stored.
- Asking Claude to "forget" files **deletes nothing**, and Claude saying "nothing remains" is not a check done by a person.
- **Feedback buttons:** Claude for Work (commercial) data is **not used for training by default**. **Feedback is the exception:** clicking thumbs-up or thumbs-down sends **the whole related conversation** to Anthropic. It can be kept **for up to 5 years** and may be used for training.
- Don't rate chats that contain client or confidential content when your policy forbids sharing it with vendors.
- Each control answers a different question: *Where is the data stored?* · *Who can see it?* · *What leaves the workspace?*

### 3. Output Evaluation and Quality Control (Q36, Q63)

#### Claims that sound right but aren't in the source (Q36)
- Claude writes a guess and a supported fact **in the same confident voice**.
- Checking the numbers confirms **only the numbers**. **Trace every claim separately**, including **causes and explanations**.
- Timing ("installed in March, score fell after") is not evidence of cause. A survey can show *that* something changed, not *why*.
- **Fix:** find the passage in the source. If it isn't there, **remove the claim or mark it as unconfirmed**.
- **Things that don't count as checking:** numbers that match, Claude confirming its own claim, or a stronger model giving the same answer again. None of these compare the claim with the source.

#### Making a document stand on its own (Q63)
A summary written at the end of a long chat is written for **the person who was in the chat**. Before it goes to other readers:
- Replace references to the chat ("the table above") with the actual content.
- Replace labels you made up during the chat ("Group A") with names readers already use.
- **State the time period and the data source.**
- The findings stay the same; only how they're presented changes. **Check the numbers again after any rewrite.**
- **Format is not content.** Moving the same text into an artifact gives you a separate document, but the text still depends on the chat. Making it self-contained is a **content** edit.

### 4. Workflow Design and Integration (Q5)

#### Explaining connectors and what Claude knows to new users
New users make **two opposite mistakes**: expecting Claude to see or know **more** than it does, or to be able to do **less** than it can.
- **Connector permissions:** a connector like Google Drive uses **the signed-in person's permissions**. Claude can reach only the files that person can already open. (Sharing settings still matter: if you give someone access to a folder, Claude can reach it in their session.)
- **Training cutoff:** Claude's built-in knowledge may be **out of date** and can state an old rule with confidence. With web search off, it can't look up recent changes.
- **Claude can still use new material you give it.** It can read and apply recent documents you supply. Saying "it can't use any rule adopted after its training" **understates what it can do**.
- **What to tell them:** supply the current text, and have a person check each item against it.

### 5. Task Definition and Prompting (Q64)

#### Breaking work into steps
Each step should have **one action**, **one output a person can check**, and **no dependency on something that hasn't happened yet**.
- When a step needs a missing input (such as a board decision), Claude **assumes something reasonable and keeps going**. The result looks finished, so the assumption is easy to miss.
- If one step passes its check, **that tells you nothing about the steps after it**.
- **Some checkpoints are for decisions, not just accuracy checks:** stop where a person with authority has to decide, then continue using their actual choice.
- **Wrong fixes:** asking Claude to justify its pick (you get a more convincing argument for an option nobody chose yet), using a stronger model (the problem is the missing decision, not the reasoning), or drafting every possible version (wasted work, and it still ignores changes the board might make).

### Quick-recall checklist
- [ ] Team needs one source → **shared Project**; personal facts everywhere → **memory** (then check it in settings)
- [ ] Procedure still changing → keep prompting; **settle it, then build a Skill**
- [ ] Opus or higher effort ≠ better context: check what each person gives Claude first
- [ ] Skill trust check: **source · reach · appropriateness** → enable / review / decline
- [ ] Project knowledge persists until **deleted**; removing members ≠ deleting
- [ ] Thumbs-up/down sends the **whole chat** to Anthropic (kept up to 5 years, may be used for training)
- [ ] Check claims of cause separately from the numbers
- [ ] Before forwarding: replace chat references, use real names, state the period and source
- [ ] Connectors = the signed-in person's permissions; Claude can apply new documents you supply
- [ ] Stop the sequence where a human decision is still pending
