import puppeteer from 'puppeteer-extra';
import { env } from 'process';
import assert from 'assert';
import StealthPlugin from 'puppeteer-extra-plugin-stealth';
import fs from 'fs';

puppeteer.use(StealthPlugin());

const ent_login = '#TopNavigationReactTarget > header > div > div.TopNavigation-contentRight > div.SiteNavLoginSection-loginButton > button > span';
const username = '#username';
const password = '#password';
const btn_login = 'body > div:nth-child(18) > div > div > div.c1yw38c3.c1cv2anc > section > div.avsxyiq > div > form > button > span > div > span';
const host = 'https://quizlet.com';
const redir_url = 'https://quizlet.com/latest';
const edit_studyset = 'https://quizlet.com/683855692/edit#addRow';
const entry_import = '#SetPageTarget > div > div.CreateSetHeader > div:nth-child(3) > div > button';
const text_area = '#SetPageTarget > div > div.ImportTerms.is-showing > div.ImportTerms-import > div > form > textarea';
const btn_import = '#SetPageTarget > div > div.ImportTerms.is-showing > div.ImportTerms-import > div > form > div.ImportTerms-importButtonWrap > button';
const request_url = 'https://quizlet.com/webapi/3.2/terms/save?_method=PUT';


(async () => {
  const browser = await puppeteer.launch({args: ['--no-sandbox']});
  const page = await browser.newPage();
  page.setDefaultTimeout(10000);
  // login
  await page.goto(host, {waitUntil: "load"});
  await page.click(ent_login);
  await page.screenshot({ path: env.LOG+'login_page.png' });
  await page.type(username, env.USERNAME);
  await page.type(password, env.PASSWORD);
  await Promise.all([
    page.keyboard.press('Enter'),
    page.waitForNavigation({waitUntil: 'networkidle2'})
  ]);
  await page.screenshot({ path: env.LOG+'after_login.png' });
  assert(page.url(), redir_url);

  // enter edit page
  await page.goto(edit_studyset, {waitUntil: "load"});
  await page.screenshot({ path: env.LOG+'edit_page.png' });
  await Promise.all([
    page.waitForSelector(text_area),
    page.click(entry_import),
    page.waitForSelector(btn_import)
  ]);
  
  // post data
  fs.readFile(env.FILEPATH, { encoding: 'utf-8' }, async (err, data) => {
    if(err) {
      throw err;
    } else {
      try {
        await page.type(text_area, data);
        await page.waitForTimeout(1000);
        await page.screenshot({ path: env.LOG+'wait_btn.png' });
        // await page.waitForSelector(btn_import+":not([disabled])");
        await page.click(btn_import);
      } catch(e) {
        throw e
      }
      const response = await page.waitForResponse(request_url);
      assert.equal(response.status(), 200);
      await page.screenshot({ path: env.LOG+'after_post.png' });
      await browser.close();
    }
  });
})();
